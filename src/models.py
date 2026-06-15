import argparse
import json
import sys

try:
    import tomllib
except ImportError:  # pragma: no cover
    print("Error: Python 3.11+ is required for openreturn-models (tomllib not found).", file=sys.stderr)
    sys.exit(1)

from database import OpenReturnDB
from scoring.engine import (_PATHS as _VALID_INPUTS, FORMULA_TYPES,
                            FORMULA_INPUT_COUNTS, _FACTOR_PREFIX, _MODEL_PREFIX)
from scoring.graph import find_cycle

_MODEL_KEYS  = {'version', 'description', 'type', 'mode', 'kind'}
_FACTOR_KEYS = {'name', 'weight', 'formula_type', 'inputs', 'direction',
                'benchmark_lo', 'benchmark_hi', 'formula_description', 'scale'}
_FACTOR_REQUIRED = {'name', 'weight', 'formula_type', 'inputs', 'direction',
                    'benchmark_lo', 'benchmark_hi'}

_MODES = ('computed', 'manual')
# How a model is composed. 'model' (default) reads 990 fields; 'composite' weights
# base models' scores; 'super_composite' weights composites' scores. The latter two
# reference children via model:<version> inputs (see _MODEL_PREFIX).
_KINDS = ('model', 'composite', 'super_composite')
# What each composing kind is allowed to reference.
_CHILD_KIND = {'composite': 'model', 'super_composite': 'composite'}
_MANUAL_SCALES = ('benchmark', 'normalized', 'percent')
# A manual (graded) factor: a person supplies a value + comment via the grading
# API. No formula/inputs; `scale` says how the value maps to [0,1].
_MANUAL_FACTOR_REQUIRED = {'name', 'weight', 'scale'}


def _validate_manual_factor(factor: dict, i: int, issues: list, seen_names: set,
                            weights: list) -> None:
    label = factor.get('name', '?') if isinstance(factor, dict) else '?'
    prefix = f"factor[{i}] ({label})"
    if not isinstance(factor, dict):
        issues.append(f"ERROR: {prefix} must be a table")
        return

    for key in factor:
        if key not in _FACTOR_KEYS:
            issues.append(f"ERROR: {prefix}: unknown key '{key}'")
    for req in _MANUAL_FACTOR_REQUIRED:
        if req not in factor:
            issues.append(f"ERROR: {prefix}: missing required field '{req}'")

    name = factor.get('name')
    if isinstance(name, str):
        if name in seen_names:
            issues.append(f"ERROR: {prefix}: duplicate factor name '{name}'")
        seen_names.add(name)

    weight = factor.get('weight')
    if weight is not None:
        if not isinstance(weight, (int, float)) or float(weight) < 0:
            issues.append(f"ERROR: {prefix}: weight must be a non-negative number, got: {weight!r}")
        else:
            weights.append(float(weight))

    ft = factor.get('formula_type')
    if ft is not None and ft != 'manual':
        issues.append(f"ERROR: {prefix}: manual-model factors must omit formula_type "
                      f"or set it to 'manual', got: {ft!r}")
    if 'inputs' in factor and factor['inputs'] not in ([], None):
        issues.append(f"ERROR: {prefix}: manual factors take no inputs")

    scale = factor.get('scale')
    if scale is not None and scale not in _MANUAL_SCALES:
        issues.append(f"ERROR: {prefix}: scale must be one of {list(_MANUAL_SCALES)}, got: {scale!r}")

    # benchmark scale reuses direction + benchmark_lo/hi (like computed factors)
    if scale == 'benchmark':
        direction = factor.get('direction')
        if direction not in ('higher', 'lower'):
            issues.append(f"ERROR: {prefix}: scale 'benchmark' requires direction 'higher' or 'lower'")
        lo, hi = factor.get('benchmark_lo'), factor.get('benchmark_hi')
        if not isinstance(lo, (int, float)) or not isinstance(hi, (int, float)):
            issues.append(f"ERROR: {prefix}: scale 'benchmark' requires numeric benchmark_lo/benchmark_hi")
        elif float(lo) >= float(hi):
            issues.append(f"ERROR: {prefix}: benchmark_lo ({lo}) must be less than benchmark_hi ({hi})")


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

    mode = model.get('mode', 'computed')
    if mode not in _MODES:
        issues.append(f"ERROR: [model].mode must be one of {list(_MODES)}, got: {mode!r}")
    if 'type' in model and not isinstance(model['type'], str):
        issues.append(f"ERROR: [model].type must be a string, got: {model['type']!r}")

    kind = model.get('kind', 'model')
    if kind not in _KINDS:
        issues.append(f"ERROR: [model].kind must be one of {list(_KINDS)}, got: {kind!r}")
        kind = 'model'  # fall back so the input checks below have a sane value
    # A composite/super-composite aggregates other models' computed totals; it has
    # no person-graded values, so it cannot be manual.
    if mode == 'manual' and kind != 'model':
        issues.append(f"ERROR: a '{kind}' model cannot be manual — composites weight "
                      f"other models' computed scores")

    # [[factor]] list
    factors = data.get('factor', [])
    if not isinstance(factors, list):
        issues.append("ERROR: [[factor]] must be an array of tables")
        return issues

    if not factors:
        issues.append("ERROR: at least one [[factor]] entry is required")

    seen_names: set[str] = set()
    weights: list[float] = []
    model_ref_count = 0  # model:<v> references across all factors (composites)

    # Manual (graded) models validate their factors differently and have no
    # formulas/inputs/dependency graph — handle them and return early.
    if mode == 'manual':
        for i, factor in enumerate(factors):
            _validate_manual_factor(factor, i, issues, seen_names, weights)
        if weights and abs(sum(weights) - 1.0) > 0.001:
            issues.append(f"WARNING: factor weights sum to {sum(weights):.4f}, expected 1.0")
        return issues

    for i, factor in enumerate(factors):
        label = factor.get('name', '?') if isinstance(factor, dict) else '?'
        prefix = f"factor[{i}] ({label})"

        if not isinstance(factor, dict):
            issues.append(f"ERROR: {prefix} must be a table")
            continue

        for key in factor:
            if key not in _FACTOR_KEYS:
                issues.append(f"ERROR: {prefix}: unknown key '{key}'")
        if 'scale' in factor:
            issues.append(f"ERROR: {prefix}: 'scale' is for manual models only "
                          f"(set [model].mode = 'manual')")

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
            if not isinstance(weight, (int, float)) or float(weight) < 0:
                issues.append(f"ERROR: {prefix}: weight must be a non-negative number, got: {weight!r}")
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
                factor_names = {
                    f.get('name') for f in factors
                    if isinstance(f, dict) and isinstance(f.get('name'), str)
                }
                for inp in inputs:
                    if isinstance(inp, str) and inp.startswith(_FACTOR_PREFIX):
                        ref = inp[len(_FACTOR_PREFIX):]
                        if not ref:
                            issues.append(f"ERROR: {prefix}: 'factor:' reference must include a name")
                        elif ref not in factor_names:
                            issues.append(
                                f"ERROR: {prefix}: references unknown factor '{ref}'"
                            )
                    elif isinstance(inp, str) and inp.startswith(_MODEL_PREFIX):
                        # model:<version> — composing another model's final score.
                        if kind == 'model':
                            issues.append(
                                f"ERROR: {prefix}: a base 'model' cannot reference other "
                                f"models ('{inp}'); set [model].kind = 'composite' or "
                                f"'super_composite'")
                        ref = inp[len(_MODEL_PREFIX):]
                        # Canonical positive integer, no leading zeros (model:01).
                        if not ref.isdigit() or int(ref) <= 0 or ref != str(int(ref)):
                            issues.append(
                                f"ERROR: {prefix}: 'model:' reference must be a positive "
                                f"integer version, got: '{inp}'")
                        else:
                            model_ref_count += 1
                    elif isinstance(inp, str):
                        try:
                            float(inp)
                        except ValueError:
                            if kind != 'model':
                                issues.append(
                                    f"ERROR: {prefix}: a '{kind}' factor takes only "
                                    f"'model:<version>', 'factor:<name>', or numeric inputs — "
                                    f"not the 990 field key '{inp}'")
                            elif inp not in _VALID_INPUTS:
                                issues.append(
                                    f"ERROR: {prefix}: unknown input key '{inp}'. "
                                    f"Must be one of: {sorted(_VALID_INPUTS)}, a numeric literal, "
                                    f"or 'factor:<name>'"
                                )
                    elif isinstance(inp, (int, float)):
                        # A numeric literal must be a *quoted* string — inputs are
                        # stored/looked up as strings (the engine calls .startswith
                        # on each key), so a bare TOML number can't be resolved.
                        issues.append(
                            f"ERROR: {prefix}: numeric literal {inp!r} must be a quoted "
                            f'string, e.g. "{inp}"')
                    else:
                        issues.append(
                            f"ERROR: {prefix}: input must be a string, got: {inp!r}")
                if formula_type and formula_type in FORMULA_INPUT_COUNTS:
                    expected = FORMULA_INPUT_COUNTS[formula_type]
                    if expected is None:
                        if len(inputs) < 1:
                            issues.append(
                                f"ERROR: {prefix}: formula_type '{formula_type}' requires "
                                f"at least 1 input, got 0"
                            )
                    elif len(inputs) != expected:
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

    # A composite/super-composite must actually compose something.
    if kind in _CHILD_KIND and model_ref_count == 0:
        issues.append(
            f"ERROR: a '{kind}' model must reference at least one child via "
            f"'model:<version>' (it weights other models' scores)")

    # Check for circular factor:X dependencies
    dep_graph: dict[str, set[str]] = {}
    for f in factors:
        if not isinstance(f, dict) or not isinstance(f.get('name'), str):
            continue
        name = f['name']
        inp_list = f.get('inputs', [])
        if not isinstance(inp_list, list):
            continue
        deps: set[str] = set()
        for inp in inp_list:
            if isinstance(inp, str) and inp.startswith(_FACTOR_PREFIX):
                deps.add(inp[len(_FACTOR_PREFIX):])
        dep_graph[name] = deps

    cycle = find_cycle(dep_graph)
    if cycle:
        issues.append(f"ERROR: circular factor dependency: {' → '.join(cycle)}")

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

    db = OpenReturnDB(path=args.db)
    description = data['model'].get('description')
    mode = data['model'].get('mode', 'computed')
    model_type = data['model'].get('type')
    kind = data['model'].get('kind', 'model')

    if model_type is not None:
        valid_types = {t['code'] for t in db.scores.list_model_types()}
        if model_type not in valid_types:
            print(f"ERROR: unknown model type '{model_type}'. Known types: "
                  f"{sorted(valid_types)}", file=sys.stderr)
            db.close()
            sys.exit(1)

    # (kind is already constrained to _KINDS by validate_toml, which matches the
    # seeded model_kind table — no separate DB existence check needed here.)

    # A composite/super-composite must reference models that already exist, are
    # the right kind (composite → base models; super → composites), and are
    # computed (their totals are derived, not graded). validate_toml already
    # confirmed the model:<v> tokens are well-formed; this checks them against the
    # DB, which it could not see.
    if kind in _CHILD_KIND:
        want_kind = _CHILD_KIND[kind]
        refs = sorted({
            int(inp[len(_MODEL_PREFIX):])
            for factor in data['factor']
            for inp in (factor.get('inputs') or [])
            if isinstance(inp, str) and inp.startswith(_MODEL_PREFIX)
            and inp[len(_MODEL_PREFIX):].isdigit()
        })
        ref_errors = []
        for ref in refs:
            child = db.scores.get_model(ref)
            if child is None:
                ref_errors.append(f"references model version {ref}, which is not registered")
            elif not db.scores.get_factors(ref):
                ref_errors.append(f"references model version {ref}, which has no factors "
                                  f"(its score would always be 0)")
            elif child.get('scoring_mode') == 'manual':
                ref_errors.append(f"references manual model version {ref}; only computed "
                                  f"models can be composed")
            elif child.get('model_kind', 'model') != want_kind:
                ref_errors.append(f"is a '{kind}' but references version {ref}, which is a "
                                  f"'{child.get('model_kind', 'model')}' (expected '{want_kind}')")
        if ref_errors:
            for e in ref_errors:
                print(f"ERROR: model {e}.", file=sys.stderr)
            db.close()
            sys.exit(1)

    existing = db.cursor.execute(
        "SELECT 1 FROM score_model WHERE version = ?", (version,)
    ).fetchone()
    if existing:
        if args.skip_existing:
            print(f"Model version {version} already registered, skipping.")
            db.close()
            return
        print(f"ERROR: model version {version} is already registered.", file=sys.stderr)
        db.close()
        sys.exit(1)

    db.cursor.execute(
        "INSERT INTO score_model (version, description, model_type, scoring_mode, model_kind) "
        "VALUES (?, ?, ?, ?, ?)",
        (version, description, model_type, mode, kind)
    )
    model_id = db.cursor.lastrowid

    for factor in data['factor']:
        if mode == 'manual':
            db.cursor.execute(
                """
                INSERT INTO score_factor
                  (model_id, name, weight, formula_type, inputs, direction,
                   benchmark_lo, benchmark_hi, manual_scale, formula_description)
                VALUES (?, ?, ?, 'manual', '[]', ?, ?, ?, ?, ?)
                """,
                (
                    model_id,
                    factor['name'],
                    factor['weight'],
                    factor.get('direction', 'higher'),
                    factor.get('benchmark_lo', 0.0),
                    factor.get('benchmark_hi', 1.0),
                    factor['scale'],
                    factor.get('formula_description'),
                )
            )
        else:
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
    label = f"{mode} {model_type or ''} {kind}".replace('  ', ' ').strip()
    print(f"Registered {label} model version {version} with {n_factors} factors.")
    db.close()


def cmd_list(args) -> None:
    db = OpenReturnDB(path=args.db)
    models = db.scores.list_models()
    db.close()
    if not models:
        print("No models registered.")
        return
    for m in models:
        kind = m.get('model_kind', 'model')
        kind_tag = "" if kind == 'model' else f"/{kind}"
        tags = f"[{m['model_type'] or '?'}/{m['scoring_mode']}{kind_tag}]"
        desc = f" — {m['description']}" if m['description'] else ""
        print(f"  v{m['version']} {tags}{desc}  (created {m['created_at']})")


def main() -> None:
    parser = argparse.ArgumentParser(prog='openreturn-models', description='Manage OpenReturn scoring models')
    parser.add_argument('--db', default=None, help='Path to OpenReturn.db (defaults to ./OpenReturn.db)')
    sub = parser.add_subparsers(dest='command', required=True)

    reg = sub.add_parser('register', help='Register a scoring model from a TOML file')
    reg.add_argument('file', help='Path to the TOML model definition')
    reg.add_argument('--dry-run', action='store_true', dest='dry_run',
                     help='Validate without writing to the database')
    reg.add_argument('--skip-existing', action='store_true', dest='skip_existing',
                     help='Exit successfully if this model version is already registered')

    sub.add_parser('list', help='List registered scoring models')

    args = parser.parse_args()

    if args.command == 'register':
        cmd_register(args)
    elif args.command == 'list':
        cmd_list(args)


if __name__ == '__main__':  # pragma: no cover
    main()
