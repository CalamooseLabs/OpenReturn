import argparse
import json
import sys

try:
    import tomllib
except ImportError:  # pragma: no cover
    print("Error: Python 3.11+ is required for openreturn-models (tomllib not found).", file=sys.stderr)
    sys.exit(1)

from database.Score import ScoreDatabase
from scoring.engine import _PATHS as _VALID_INPUTS, FORMULA_TYPES, FORMULA_INPUT_COUNTS

_MODEL_KEYS  = {'version', 'description'}
_FACTOR_KEYS = {'name', 'weight', 'formula_type', 'inputs', 'direction',
                'benchmark_lo', 'benchmark_hi', 'formula_description'}
_FACTOR_REQUIRED = {'name', 'weight', 'formula_type', 'inputs', 'direction',
                    'benchmark_lo', 'benchmark_hi'}


def validate_toml(data: dict) -> list[str]:
    """Validate a parsed TOML model definition.

    Returns a list of diagnostic strings.  Each entry starts with either
    'ERROR:' (which blocks registration) or 'WARNING:' (advisory only).
    """
    issues: list[str] = []

    # Unknown top-level keys
    known_top = {'model', 'factor'}
    for key in data:
        if key not in known_top:
            issues.append(f"ERROR: unknown top-level key: '{key}'")

    # [model] section
    if 'model' not in data:
        issues.append("ERROR: missing [model] section")
        return issues

    model = data['model']
    if not isinstance(model, dict):
        issues.append("ERROR: [model] must be a table")
        return issues

    for key in model:
        if key not in _MODEL_KEYS:
            issues.append(f"ERROR: unknown key in [model]: '{key}'")

    if 'version' not in model:
        issues.append("ERROR: [model] missing required field: version")
    else:
        v = model['version']
        if not isinstance(v, int) or v <= 0:
            issues.append(f"ERROR: [model].version must be a positive integer, got: {v!r}")

    # [[factor]] list
    factors = data.get('factor', [])
    if not isinstance(factors, list):
        issues.append("ERROR: [[factor]] must be an array of tables")
        return issues

    if not factors:
        issues.append("ERROR: at least one [[factor]] entry is required")

    seen_names: set[str] = set()
    weights: list[float] = []

    for i, factor in enumerate(factors):
        label = factor.get('name', '?') if isinstance(factor, dict) else '?'
        prefix = f"factor[{i}] ({label})"

        if not isinstance(factor, dict):
            issues.append(f"ERROR: {prefix} must be a table")
            continue

        for key in factor:
            if key not in _FACTOR_KEYS:
                issues.append(f"ERROR: {prefix}: unknown key '{key}'")

        for req in _FACTOR_REQUIRED:
            if req not in factor:
                issues.append(f"ERROR: {prefix}: missing required field '{req}'")

        name = factor.get('name')
        if isinstance(name, str):
            if name in seen_names:
                issues.append(f"ERROR: {prefix}: duplicate factor name '{name}'")
            seen_names.add(name)

        weight = factor.get('weight')
        if weight is not None:
            if not isinstance(weight, (int, float)) or float(weight) <= 0:
                issues.append(f"ERROR: {prefix}: weight must be a positive number, got: {weight!r}")
            else:
                weights.append(float(weight))

        formula_type = factor.get('formula_type')
        if formula_type is not None:
            if formula_type not in FORMULA_TYPES:
                issues.append(
                    f"ERROR: {prefix}: unknown formula_type '{formula_type}'. "
                    f"Must be one of: {sorted(FORMULA_TYPES)}"
                )

        inputs = factor.get('inputs')
        if inputs is not None:
            if not isinstance(inputs, list):
                issues.append(f"ERROR: {prefix}: inputs must be an array")
            else:
                for inp in inputs:
                    if inp not in _VALID_INPUTS:
                        issues.append(
                            f"ERROR: {prefix}: unknown input key '{inp}'. "
                            f"Must be one of: {sorted(_VALID_INPUTS)}"
                        )
                if formula_type and formula_type in FORMULA_INPUT_COUNTS:
                    expected = FORMULA_INPUT_COUNTS[formula_type]
                    if len(inputs) != expected:
                        issues.append(
                            f"ERROR: {prefix}: formula_type '{formula_type}' requires "
                            f"{expected} inputs, got {len(inputs)}"
                        )

        direction = factor.get('direction')
        if direction is not None and direction not in ('higher', 'lower'):
            issues.append(f"ERROR: {prefix}: direction must be 'higher' or 'lower', got: {direction!r}")

        lo = factor.get('benchmark_lo')
        hi = factor.get('benchmark_hi')
        if lo is not None and hi is not None:
            if not isinstance(lo, (int, float)):
                issues.append(f"ERROR: {prefix}: benchmark_lo must be a number")
            elif not isinstance(hi, (int, float)):
                issues.append(f"ERROR: {prefix}: benchmark_hi must be a number")
            elif float(lo) >= float(hi):
                issues.append(
                    f"ERROR: {prefix}: benchmark_lo ({lo}) must be less than benchmark_hi ({hi})"
                )

    if weights and abs(sum(weights) - 1.0) > 0.001:
        issues.append(f"WARNING: factor weights sum to {sum(weights):.4f}, expected 1.0")

    return issues


def cmd_register(args) -> None:
    with open(args.file, 'rb') as f:
        data = tomllib.load(f)

    issues  = validate_toml(data)
    errors  = [i for i in issues if i.startswith('ERROR:')]
    warnings = [i for i in issues if i.startswith('WARNING:')]

    for w in warnings:
        print(w)

    if errors:
        for e in errors:
            print(e)
        sys.exit(1)

    version = data['model']['version']
    n_factors = len(data['factor'])

    if args.dry_run:
        print(f"Validation passed: model version {version} with {n_factors} factors")
        return

    db = ScoreDatabase(path=args.db)
    description = data['model'].get('description')

    db.cursor.execute(
        "INSERT INTO score_model (version, description) VALUES (?, ?)",
        (version, description)
    )
    model_id = db.cursor.lastrowid

    for factor in data['factor']:
        db.cursor.execute(
            """
            INSERT INTO score_factor
              (model_id, name, weight, formula_type, inputs, direction,
               benchmark_lo, benchmark_hi, formula_description)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                model_id,
                factor['name'],
                factor['weight'],
                factor['formula_type'],
                json.dumps(factor['inputs']),
                factor['direction'],
                factor['benchmark_lo'],
                factor['benchmark_hi'],
                factor.get('formula_description'),
            )
        )

    db.connection.commit()
    print(f"Registered model version {version} with {n_factors} factors.")
    db.close()


def cmd_list(args) -> None:
    db = ScoreDatabase(path=args.db)
    rows = db.cursor.execute(
        "SELECT version, description, created_at FROM score_model ORDER BY version"
    ).fetchall()
    if not rows:
        print("No models registered.")
    else:
        for r in rows:
            desc = f" — {r[1]}" if r[1] else ""
            print(f"  v{r[0]}{desc}  (created {r[2]})")
    db.close()


def main() -> None:
    parser = argparse.ArgumentParser(prog='openreturn-models', description='Manage OpenReturn scoring models')
    parser.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    sub = parser.add_subparsers(dest='command', required=True)

    reg = sub.add_parser('register', help='Register a scoring model from a TOML file')
    reg.add_argument('file', help='Path to the TOML model definition')
    reg.add_argument('--dry-run', action='store_true', dest='dry_run',
                     help='Validate without writing to the database')

    sub.add_parser('list', help='List registered scoring models')

    args = parser.parse_args()

    if args.command == 'register':
        cmd_register(args)
    elif args.command == 'list':
        cmd_list(args)


if __name__ == '__main__':  # pragma: no cover
    main()
