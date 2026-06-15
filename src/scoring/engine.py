from __future__ import annotations
import json
import math

_FACTOR_PREFIX = 'factor:'
# A composite / super-composite factor input that resolves to another model's
# final total_score for the same filing, e.g. "model:10". The referenced version
# must already be evaluated (the engine orders base models before composites
# before super-composites), and is looked up in the per-filing model_totals map.
_MODEL_PREFIX = 'model:'

_PATHS: dict[str, str] = {
    'prog':       'ReturnData/IRS990/TotalFunctionalExpensesGrp/ProgramServicesAmt',
    'admin':      'ReturnData/IRS990/TotalFunctionalExpensesGrp/ManagementAndGeneralAmt',
    'fund':       'ReturnData/IRS990/TotalFunctionalExpensesGrp/FundraisingAmt',
    'total_exp':  'ReturnData/IRS990/TotalFunctionalExpensesGrp/TotalAmt',
    'cy_exp':     'ReturnData/IRS990/CYTotalExpensesAmt',
    'py_exp':     'ReturnData/IRS990/PYTotalExpensesAmt',
    'cy_rev':     'ReturnData/IRS990/CYTotalRevenueAmt',
    'cy_grants':  'ReturnData/IRS990/CYGrantsAndSimilarPaidAmt',
    'py_grants':  'ReturnData/IRS990/PYGrantsAndSimilarPaidAmt',
    'contrib':    'ReturnData/IRS990/TotalContributionsAmt',
    'gov_grants': 'ReturnData/IRS990/GovernmentGrantsAmt',
    'invest_inc': 'ReturnData/IRS990/CYInvestmentIncomeAmt',
    'assets':     'ReturnData/IRS990/TotalAssetsEOYAmt',
    'liabilities':'ReturnData/IRS990/TotalLiabilitiesEOYAmt',
    'equity':     'ReturnData/IRS990/NetAssetsOrFundBalancesEOYAmt',
    'cash':       'ReturnData/IRS990/CashNonInterestBearingGrp/EOYAmt',
    'savings':    'ReturnData/IRS990/SavingsAndTempCashInvstGrp/EOYAmt',
    'invest_val': 'ReturnData/IRS990/InvestmentsOtherSecuritiesGrp/EOYAmt',
    'accts_pay':  'ReturnData/IRS990/AccountsPayableAccrExpnssGrp/EOYAmt',
}

# None means variable-length (1+ inputs accepted); integer means exact count required.
FORMULA_TYPES = {
    # Original
    'ratio', 'ratio_positive', 'growth', 'working_capital', 'sum_ratio',
    # Fixed, 2-input
    'difference', 'product',
    # Fixed, 3-input
    'clamp',
    # Fixed, 1-input
    'abs_value', 'inverse',
    # Variable-length (1+ inputs) — None values are skipped
    'sum', 'average', 'min', 'max', 'median',
    # Historical: operate over all available years of data for the org (1 field-key input)
    'running_average', 'cumulative_sum', 'historical_min', 'historical_max',
    'cagr', 'historical_std_dev', 'coefficient_of_variation',
}
FORMULA_INPUT_COUNTS: dict[str, int | None] = {
    'ratio':                    2,
    'ratio_positive':           2,
    'growth':                   2,
    'working_capital':          4,
    'sum_ratio':                3,
    'difference':               2,
    'product':                  2,
    'clamp':                    3,
    'abs_value':                1,
    'inverse':                  1,
    'sum':                      None,
    'average':                  None,
    'min':                      None,
    'max':                      None,
    'median':                   None,
    'running_average':          1,
    'cumulative_sum':           1,
    'historical_min':           1,
    'historical_max':           1,
    'cagr':                     1,
    'historical_std_dev':       1,
    'coefficient_of_variation': 1,
}

_HISTORICAL_TYPES = frozenset({
    'running_average', 'cumulative_sum', 'historical_min', 'historical_max',
    'cagr', 'historical_std_dev', 'coefficient_of_variation',
})

# The fields any scoring formula can read — the only reported_data the batch
# loader needs to fetch per org.
_SCORING_PATHS = frozenset(_PATHS.values())


def _fmt_num(v) -> str:
    """Render a number for the debug walkthrough's substituted formulas: integral
    floats lose the trailing '.0', others use compact 6-significant-figure form,
    and None (a missing input) shows as 'None'."""
    if v is None:
        return "None"
    if isinstance(v, bool):
        return str(v)
    if isinstance(v, (int, float)):
        f = float(v)
        if f == int(f) and abs(f) < 1e15:
            return str(int(f))
        return f"{f:.6g}"
    return str(v)


class ScoringEngine:
    def __init__(self, db) -> None:
        self.db = db

    def calculate(self, ein: str, year: int, model_version: int = 1) -> dict:
        filing = self.db.filings.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        vals = self._load_values(filing['fields'])
        factors = self.db.scores.get_factors(model_version)
        if not factors:
            raise ValueError(f"Score model version {model_version} has no factors")
        model = self.db.scores.get_model(model_version)
        if model and model.get('scoring_mode') == 'manual':
            raise ValueError(
                f"Score model version {model_version} is manual — grade its factors "
                f"via POST /scores/grade instead of calculate")
        sorted_factors = self._topo_sort(factors)

        # Composites/super-composites read other models' totals for THIS filing;
        # compute the dependency chain on the fly so calculate() is self-contained
        # regardless of whether the batch path pre-stored child scores. Their
        # children may use historical formulas, so load the org history for the
        # whole chain; a base model loads history only if it needs it.
        is_composite = (model or {}).get('model_kind', 'model') in ('composite', 'super_composite')
        needs_history = is_composite or any(
            f['formula_type'] in _HISTORICAL_TYPES for f in sorted_factors)
        historical: dict[str, list[float]] = \
            self.db.reported_data.get_historical_values(ein) if needs_history else {}
        model_totals = (self._compute_dependency_totals(model_version, vals, historical)
                        if is_composite else {})

        total, factor_list = self._score_model_for_filing(
            sorted_factors, vals, historical, model_totals)
        factor_results = {fid: (raw, weighted) for fid, raw, weighted in factor_list}

        score_id = self.db.scores.create_score(filing['filing_id'], model_version)
        self.db.scores.store_factor_values(score_id, factor_results)
        self.db.scores.finalize_score(score_id, total)

        return self.db.scores.get_score(score_id)

    # ── Batch / pre-computation ──────────────────────────────────────────────
    # calculate() above is the single-filing API path (one filing, round-trips
    # through get_score). The methods below pre-compute and store scores in bulk
    # for every computed (non-manual) model across many filings, grouped by org
    # so each org's history + values load once and a fresh history reshapes every
    # year's score. Manual models are skipped (they are graded, not computed).

    def _prepare_models(self, model_versions=None) -> list[dict]:
        """Resolve the computed models to score into ready-to-evaluate form:
        {version, model_id, kind, factors (topo-sorted), needs_history, deps}.
        Optionally restricted to ``model_versions``. Empty (factorless) models are
        skipped. The returned list is ordered so a composite's ``model:<v>``
        dependencies appear before it (base → composite → super-composite).

        When ``model_versions`` restricts the set, transitive ``model:<v>``
        dependencies are pulled back in (and re-scored) — scoring a composite
        alone is meaningless without current child-model totals."""
        computed = self.db.scores.list_computed_models()
        if model_versions is not None:
            by_version = {m['version']: m for m in computed}
            want: set[int] = set()
            stack = [v for v in model_versions if v in by_version]
            while stack:
                v = stack.pop()
                if v in want:
                    continue
                want.add(v)
                for dep in self._model_refs(self.db.scores.get_factors(v)):
                    if dep in by_version and dep not in want:
                        stack.append(dep)
            computed = [m for m in computed if m['version'] in want]
        prepared_by_version: dict[int, dict] = {}
        for m in computed:
            factors = self.db.scores.get_factors(m['version'])
            if not factors:
                continue
            sorted_factors = self._topo_sort(factors)
            prepared_by_version[m['version']] = {
                "version":       m['version'],
                "model_id":      m['model_id'],
                "kind":          m.get('model_kind', 'model'),
                "factors":       sorted_factors,
                "needs_history": any(f['formula_type'] in _HISTORICAL_TYPES for f in sorted_factors),
                "deps":          self._model_refs(sorted_factors),
            }
        return [prepared_by_version[v] for v in self._order_versions(prepared_by_version)]

    def score_org(self, ein: str, prepared_models: list[dict],
                  scoring_paths=_SCORING_PATHS) -> int:
        """(Re)compute and store every prepared model's score for every filing of
        one org, in a single bulk replace (no commit — the caller batches). The
        org's values + history load once and are reused across its years/models.
        Composites read base-model totals for the same filing, so models run in
        dependency order while a per-filing {version: total} map accumulates.
        Returns the number of scores written."""
        if not prepared_models:
            return 0
        filings, vals_by_uuid, historical = \
            self.db.reported_data.get_org_scoring_data(ein, scoring_paths)
        if not filings:
            return 0
        # Per-filing {version: total}; a composite's model:<v> inputs find their
        # child totals here because prepared_models is dependency-ordered.
        totals_by_filing: dict[str, dict[int, float | None]] = {
            fil['filing_id']: {} for fil in filings}
        results = []
        for m in prepared_models:
            hist = historical if m['needs_history'] else {}
            for fil in filings:
                fid = fil['filing_id']
                vals = vals_by_uuid.get(fid, {})
                model_totals = totals_by_filing[fid]
                total, factor_results = self._score_model_for_filing(
                    m['factors'], vals, hist, model_totals)
                model_totals[m['version']] = total
                results.append((fid, m['model_id'], total, factor_results))
        self.db.scores.replace_org_scores(ein, [m['model_id'] for m in prepared_models], results)
        return len(results)

    def rebuild(self, model_versions=None, eins=None, *,
                batch_size: int = 500, progress=None) -> dict:
        """Pre-compute + store scores for computed models across many orgs.

        ``model_versions`` limits to specific versions (default: all computed);
        ``eins`` limits to specific orgs (default: every org — a full rebuild).
        Commits every ``batch_size`` orgs. ``progress`` (if given) is called as
        ``progress(orgs_done, orgs_total, scores_written)`` each batch. Returns
        ``{"orgs", "scores", "models"}``."""
        prepared = self._prepare_models(model_versions)
        if not prepared:
            return {"orgs": 0, "scores": 0, "models": 0}
        eins = self.db.scores.all_eins() if eins is None else list(eins)
        total = len(eins)
        scores = 0
        for i, ein in enumerate(eins, 1):
            scores += self.score_org(ein, prepared)
            if i % batch_size == 0:
                self.db.commit()
                if progress:
                    progress(i, total, scores)
        self.db.commit()
        if progress:
            progress(total, total, scores)
        return {"orgs": total, "scores": scores, "models": len(prepared)}

    def _topo_sort(self, factors: list[dict]) -> list[dict]:
        name_to_factor = {f['name']: f for f in factors}
        visited:  set[str] = set()
        in_stack: set[str] = set()
        order: list[dict] = []

        def visit(name: str) -> None:
            if name in in_stack:
                raise ValueError(f"Circular factor dependency involving '{name}'")
            if name in visited:
                return
            in_stack.add(name)
            for inp in json.loads(name_to_factor[name]['inputs']):
                if inp.startswith(_FACTOR_PREFIX):
                    dep = inp[len(_FACTOR_PREFIX):]
                    if dep not in name_to_factor:
                        raise ValueError(f"Factor '{name}' references unknown factor '{dep}'")
                    visit(dep)
            in_stack.discard(name)
            visited.add(name)
            order.append(name_to_factor[name])

        for f in factors:
            visit(f['name'])
        return order

    # ── Cross-model composition (composites / super-composites) ───────────────
    # A composite's factors take model:<version> inputs that resolve to another
    # model's total_score for the SAME filing; a super-composite does the same over
    # composites. Models are evaluated base → composite → super-composite (a
    # topological order over these refs) so each layer's inputs are ready.

    @staticmethod
    def _model_refs(factors: list[dict]) -> set[int]:
        """The model:<version> versions referenced across a model's factors — the
        other models a composite/super-composite depends on."""
        refs: set[int] = set()
        for f in factors:
            for inp in json.loads(f['inputs']):
                if isinstance(inp, str) and inp.startswith(_MODEL_PREFIX):
                    try:
                        refs.add(int(inp[len(_MODEL_PREFIX):]))
                    except (ValueError, TypeError):
                        pass
        return refs

    def _score_model_for_filing(self, factors: list[dict], vals: dict[str, float],
                                historical: dict[str, list[float]],
                                model_totals: dict[int, float | None]):
        """Evaluate one model's (topo-sorted) factors against a single filing.
        Returns ``(total_score, [(factor_id, raw, weighted), ...])``. ``model_totals``
        is the ``{version: total}`` of already-scored models for this filing (for
        ``model:<version>`` inputs); pass ``{}`` for a base model. This is the shared
        per-(model, filing) primitive behind both calculate() and the batch path."""
        computed: dict[str, float | None] = {}
        factor_results: list[tuple[int, float | None, float]] = []
        total = 0.0
        for f in factors:
            raw = self._compute_factor(f, vals, computed, historical, model_totals)
            computed[f['name']] = raw
            weighted = self._normalize(f, raw) * f['weight']
            total += weighted
            factor_results.append((f['factor_id'], raw, weighted))
        return total, factor_results

    @staticmethod
    def _order_versions(prepared: dict[int, dict]) -> list[int]:
        """Topologically order prepared model versions so a model's ``model:<v>``
        dependencies score before it. Deps on versions not in ``prepared`` (manual,
        factorless, or outside a requested subset) are skipped for ordering — they
        resolve to None at score time. Raises on a dependency cycle."""
        order: list[int] = []
        visited: set[int] = set()
        in_stack: set[int] = set()

        def visit(v: int) -> None:
            if v in in_stack:
                raise ValueError(f"Circular model dependency involving version {v}")
            if v in visited or v not in prepared:
                return
            in_stack.add(v)
            for dep in prepared[v]['deps']:
                visit(dep)
            in_stack.discard(v)
            visited.add(v)
            order.append(v)

        for v in sorted(prepared):
            visit(v)
        return order

    def _dependency_order(self, target_version: int) -> list[int]:
        """Versions ``target_version`` transitively depends on (via ``model:<v>``),
        in evaluation order (dependencies first), EXCLUDING the target. Used by
        calculate() to score a composite's children on the fly for one filing.

        A child that cannot produce a total — missing, factorless, or manual — is
        **skipped** rather than scored; its ``model:<v>`` input then resolves to
        None (a 0 contribution), exactly matching the batch path's handling of an
        unresolvable dependency (``_order_versions`` skips absent deps). This keeps
        calculate() and ``rebuild`` consistent for a broken/misconfigured composite
        instead of one raising while the other silently scores 0. Registration
        (``cmd_register``) blocks creating such a composite in the first place;
        this is the defensive fallback for direct-DB edits. Raises only on a true
        dependency cycle."""
        order: list[int] = []
        visited: set[int] = set()
        in_stack: set[int] = set()

        def visit(v: int, is_target: bool) -> None:
            if v in in_stack:
                raise ValueError(f"Circular model dependency involving version {v}")
            if v in visited:
                return
            in_stack.add(v)
            factors = self.db.scores.get_factors(v)
            for dep in self._model_refs(factors):
                visit(dep, False)
            in_stack.discard(v)
            visited.add(v)
            if is_target:
                return
            # Only schedule a scoreable child: a computed model with factors.
            if not factors:
                return
            model = self.db.scores.get_model(v)
            if model and model.get('scoring_mode') == 'manual':
                return
            order.append(v)

        visit(target_version, True)
        return order

    def _compute_dependency_totals(self, target_version: int, vals: dict[str, float],
                                   historical: dict[str, list[float]]) -> dict[int, float | None]:
        """Score every model ``target_version`` depends on for a single filing,
        returning ``{version: total}`` — the model_totals a composite's factors read."""
        totals: dict[int, float | None] = {}
        for v in self._dependency_order(target_version):
            factors = self._topo_sort(self.db.scores.get_factors(v))
            total, _ = self._score_model_for_filing(factors, vals, historical, totals)
            totals[v] = total
        return totals

    def _load_values(self, fields: list[dict]) -> dict[str, float]:
        result: dict[str, float] = {}
        for f in fields:
            path = f.get('xml_path')
            raw = f.get('value')
            if path and raw is not None:
                try:
                    result[path] = float(raw)
                except (ValueError, TypeError):
                    pass
        return result

    def _resolve_input(self, key: str, vals: dict[str, float],
                       computed: dict[str, float | None],
                       model_totals: dict[int, float | None] | None = None) -> float | None:
        if key.startswith(_FACTOR_PREFIX):
            return computed.get(key[len(_FACTOR_PREFIX):])
        if key.startswith(_MODEL_PREFIX):
            ref = key[len(_MODEL_PREFIX):]
            try:
                return (model_totals or {}).get(int(ref))
            except (ValueError, TypeError):
                return None
        try:
            return float(key)
        except (ValueError, TypeError):
            pass
        path = _PATHS.get(key)
        return vals.get(path) if path else None

    def _compute_factor(self, factor: dict, vals: dict[str, float],
                        computed: dict[str, float | None] | None = None,
                        historical: dict[str, list[float]] | None = None,
                        model_totals: dict[int, float | None] | None = None) -> float | None:
        if computed is None:
            computed = {}
        if historical is None:
            historical = {}
        formula_type = factor['formula_type']
        keys = json.loads(factor['inputs'])

        # --- Historical formulas ---
        if formula_type in _HISTORICAL_TYPES:
            path = _PATHS.get(keys[0]) if keys else None
            hist = historical.get(path, []) if path else []
            if not hist:
                return None
            if formula_type == 'running_average':
                return sum(hist) / len(hist)
            if formula_type == 'cumulative_sum':
                return sum(hist)
            if formula_type == 'historical_min':
                return min(hist)
            if formula_type == 'historical_max':
                return max(hist)
            if formula_type == 'cagr':
                if len(hist) < 2 or hist[0] <= 0 or hist[-1] <= 0:
                    return None
                return (hist[-1] / hist[0]) ** (1.0 / (len(hist) - 1)) - 1.0
            if formula_type == 'historical_std_dev':
                mean = sum(hist) / len(hist)
                return math.sqrt(sum((x - mean) ** 2 for x in hist) / len(hist))
            if formula_type == 'coefficient_of_variation':
                mean = sum(hist) / len(hist)
                if mean == 0:
                    return None
                std_dev = math.sqrt(sum((x - mean) ** 2 for x in hist) / len(hist))
                return std_dev / abs(mean)

        inputs = [self._resolve_input(k, vals, computed, model_totals) for k in keys]

        # --- Fixed 2-input ---
        if formula_type == 'ratio':
            n, d = inputs[0], inputs[1]
            return n / d if n is not None and d else None

        if formula_type == 'ratio_positive':
            n, d = inputs[0], inputs[1]
            return n / d if n is not None and d and d > 0 else None

        if formula_type == 'growth':
            cy, py = inputs[0], inputs[1]
            return cy / py - 1.0 if cy is not None and py else None

        if formula_type == 'difference':
            a, b = inputs[0], inputs[1]
            return a - b if a is not None and b is not None else None

        if formula_type == 'product':
            a, b = inputs[0], inputs[1]
            return a * b if a is not None and b is not None else None

        if formula_type == 'clamp':
            v, lo, hi = inputs[0], inputs[1], inputs[2]
            return max(lo, min(hi, v)) if v is not None and lo is not None and hi is not None else None

        # --- Fixed multi-input ---
        if formula_type == 'working_capital':
            cash    = (inputs[0] or 0.0) + (inputs[1] or 0.0)
            payable = inputs[2] or 0.0
            exp     = inputs[3]
            return (cash - payable) / exp if exp else None

        if formula_type == 'sum_ratio':
            a, b, c = inputs[0], inputs[1], inputs[2]
            return (a + b) / c if c and a is not None and b is not None else None

        # --- Fixed 1-input ---
        if formula_type == 'abs_value':
            a = inputs[0]
            return abs(a) if a is not None else None

        if formula_type == 'inverse':
            a = inputs[0]
            return 1.0 / a if a else None

        # --- Variable-length (skip None inputs) ---
        non_none = [v for v in inputs if v is not None]

        if formula_type == 'sum':
            return sum(non_none) if non_none else None

        if formula_type == 'average':
            return sum(non_none) / len(non_none) if non_none else None

        if formula_type == 'min':
            return min(non_none) if non_none else None

        if formula_type == 'max':
            return max(non_none) if non_none else None

        if formula_type == 'median':
            if not non_none:
                return None
            s = sorted(non_none)
            mid = len(s) // 2
            return s[mid] if len(s) % 2 else (s[mid - 1] + s[mid]) / 2.0

        return None

    def _normalize(self, factor: dict, raw: float | None) -> float:
        """Map a raw factor value to [0, 1] using the factor's benchmark range."""
        if raw is None:
            return 0.0
        direction = factor['direction']
        lo = factor['benchmark_lo']
        hi = factor['benchmark_hi']
        span = hi - lo
        if span == 0:
            return 0.0
        if direction == 'higher':
            return max(0.0, min(1.0, (raw - lo) / span))
        else:
            return max(0.0, min(1.0, (hi - raw) / span))

    # ── Debug / walkthrough ──────────────────────────────────────────────────
    # A read-only trace of a model evaluation: for each factor, what the formula
    # is, what it looks like with this filing's numbers substituted in, every
    # variable, and — for field inputs — where the value is grabbed from (form,
    # part, section, line, xml_path). Reuses _compute_factor/_normalize so the
    # numbers shown are exactly what calculate() would persist; nothing is
    # written to the database.

    def debug(self, ein: str, year: int, model_version: int = 1) -> dict:
        filing = self.db.filings.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        fields = filing['fields']
        vals = self._load_values(fields)
        raw_by_path = {f['xml_path']: f.get('value')
                       for f in fields if f.get('xml_path')}

        factors = self.db.scores.get_factors(model_version)
        if not factors:
            raise ValueError(f"Score model version {model_version} has no factors")
        model = self.db.scores.get_model(model_version)
        if model and model.get('scoring_mode') == 'manual':
            return self._debug_manual(ein, year, filing, model, factors)
        sorted_factors = self._topo_sort(factors)

        is_composite = (model or {}).get('model_kind', 'model') in ('composite', 'super_composite')
        needs_history = is_composite or any(
            f['formula_type'] in _HISTORICAL_TYPES for f in sorted_factors)
        historical = self.db.reported_data.get_historical_values(ein) if needs_history else {}
        model_totals = (self._compute_dependency_totals(model_version, vals, historical)
                        if is_composite else {})

        source_cache: dict[str, dict | None] = {}

        def source_for(path: str) -> dict | None:
            if path not in source_cache:
                source_cache[path] = self.db.meta.get_field_source(path)
            return source_cache[path]

        computed: dict[str, float | None] = {}
        traces: list[dict] = []
        total = 0.0
        for f in sorted_factors:
            raw = self._compute_factor(f, vals, computed, historical, model_totals)
            computed[f['name']] = raw
            normalized = self._normalize(f, raw)
            weighted = normalized * f['weight']
            total += weighted
            traces.append(self._debug_factor(
                f, vals, raw_by_path, computed, historical, model_totals, source_for,
                raw, normalized, weighted))

        return {
            "ein": ein,
            "year": year,
            "filing_id": filing['filing_id'],
            "form_code": filing.get('form_code'),
            "model_version": model_version,
            "model_type": (model or {}).get('model_type'),
            "model_kind": (model or {}).get('model_kind', 'model'),
            "scoring_mode": "computed",
            "total_score": total,
            "evaluation_order": [f['name'] for f in sorted_factors],
            "factors": traces,
        }

    def _debug_factor(self, factor: dict, vals, raw_by_path, computed, historical,
                      model_totals, source_for, raw, normalized, weighted) -> dict:
        ftype = factor['formula_type']
        keys = json.loads(factor['inputs'])
        is_hist = ftype in _HISTORICAL_TYPES

        variables = [
            self._describe_variable(k, vals, raw_by_path, computed, historical,
                                    model_totals, source_for, is_hist)
            for k in keys
        ]

        return {
            "factor_id":           factor['factor_id'],
            "name":                factor['name'],
            "formula_type":        ftype,
            "weight":              factor['weight'],
            "formula_description": factor['formula_description'],
            "inputs":              keys,
            "variables":           variables,
            "formula":             self._render_formula(ftype, keys, variables, raw),
            "normalization":       self._render_normalization(factor, raw, normalized),
            "raw_value":           raw,
            "normalized":          normalized,
            "weighted_value":      weighted,
        }

    def _describe_variable(self, key: str, vals, raw_by_path, computed, historical,
                           model_totals, source_for, is_hist: bool) -> dict:
        if key.startswith(_FACTOR_PREFIX):
            name = key[len(_FACTOR_PREFIX):]
            return {"key": key, "kind": "factor", "references": name,
                    "value": computed.get(name)}
        if key.startswith(_MODEL_PREFIX):
            ref = key[len(_MODEL_PREFIX):]
            try:
                version = int(ref)
            except (ValueError, TypeError):
                version = None
            return {"key": key, "kind": "model", "references": version,
                    "value": (model_totals or {}).get(version) if version is not None else None}
        try:
            return {"key": key, "kind": "literal", "value": float(key)}
        except (ValueError, TypeError):
            pass
        path = _PATHS.get(key)
        if path is None:
            return {"key": key, "kind": "unknown", "value": None,
                    "note": "not a known field key, numeric literal, factor, or model reference"}
        var = {
            "key":       key,
            "kind":      "field",
            "xml_path":  path,
            "value":     vals.get(path),
            "raw_value": raw_by_path.get(path),
            "present":   path in vals,
            "source":    source_for(path),
        }
        if is_hist:
            var["series"] = historical.get(path, [])
        return var

    def _render_formula(self, ftype: str, keys: list, variables: list, raw) -> dict:
        if ftype in _HISTORICAL_TYPES:
            key = keys[0] if keys else "?"
            series = variables[0].get("series", []) if variables else []
            expression = self._hist_expr(ftype, f"{key}[all years]")
            substituted = self._hist_expr(ftype, "[" + ", ".join(_fmt_num(x) for x in series) + "]")
        else:
            expression = self._expr(ftype, list(keys))
            sub_vals = [v.get("value") for v in variables]
            if ftype == 'working_capital':
                # The engine treats the first three inputs (cash, savings,
                # accts_pay) as 0.0 when missing; reflect that in the substituted
                # formula so it matches the actual computation rather than showing
                # a misleading "None".
                sub_vals = [0.0 if (i < 3 and v is None) else v
                            for i, v in enumerate(sub_vals)]
            substituted = self._expr(ftype, [_fmt_num(v) for v in sub_vals])
        note = None
        if raw is None:
            note = ("formula returned no value — a required input was missing or a "
                    "denominator was zero")
        return {"type": ftype, "expression": expression, "substituted": substituted,
                "raw_value": raw, "computable": raw is not None, "note": note}

    @staticmethod
    def _expr(ftype: str, t: list) -> str:
        joined = ", ".join(t)
        if ftype in ('ratio', 'ratio_positive'):
            return f"{t[0]} / {t[1]}"
        if ftype == 'growth':
            return f"({t[0]} / {t[1]}) - 1"
        if ftype == 'difference':
            return f"{t[0]} - {t[1]}"
        if ftype == 'product':
            return f"{t[0]} * {t[1]}"
        if ftype == 'clamp':
            return f"max({t[1]}, min({t[2]}, {t[0]}))"
        if ftype == 'abs_value':
            return f"|{t[0]}|"
        if ftype == 'inverse':
            return f"1 / {t[0]}"
        if ftype == 'working_capital':
            return f"({t[0]} + {t[1]} - {t[2]}) / {t[3]}"
        if ftype == 'sum_ratio':
            return f"({t[0]} + {t[1]}) / {t[2]}"
        if ftype == 'sum':
            return " + ".join(t) if t else "0"
        if ftype == 'average':
            return f"mean({joined})"
        if ftype in ('min', 'max', 'median'):
            return f"{ftype}({joined})"
        return joined

    @staticmethod
    def _hist_expr(ftype: str, s: str) -> str:
        return {
            'running_average':          f"mean({s})",
            'cumulative_sum':           f"sum({s})",
            'historical_min':           f"min({s})",
            'historical_max':           f"max({s})",
            'cagr':                     f"(last({s}) / first({s})) ^ (1 / (n - 1)) - 1",
            'historical_std_dev':       f"pstdev({s})",
            'coefficient_of_variation': f"pstdev({s}) / |mean({s})|",
        }.get(ftype, f"{ftype}({s})")

    @staticmethod
    def _render_normalization(factor: dict, raw, normalized) -> dict:
        lo, hi = factor['benchmark_lo'], factor['benchmark_hi']
        direction = factor['direction']
        span = _fmt_num(hi - lo)
        # `expression` is the pure template (lo/hi/raw symbolic, like
        # formula.expression); the numbers live in benchmark_lo/hi + substituted.
        if direction == 'higher':
            expression = "clamp01((raw - lo) / (hi - lo))"
            substituted = (f"clamp01(({_fmt_num(raw)} - {_fmt_num(lo)}) / {span})"
                           if raw is not None else "raw is None → 0.0")
        else:
            expression = "clamp01((hi - raw) / (hi - lo))"
            substituted = (f"clamp01(({_fmt_num(hi)} - {_fmt_num(raw)}) / {span})"
                           if raw is not None else "raw is None → 0.0")
        return {"direction": direction, "benchmark_lo": lo, "benchmark_hi": hi,
                "expression": expression, "substituted": substituted,
                "normalized": normalized}

    # ── Manual / graded models ───────────────────────────────────────────────
    # A manual model's factors are scored by a person: a value + comment supplied
    # via grade(), not computed from a formula. How the value maps to [0,1]
    # depends on the factor's manual_scale.

    def _normalize_manual(self, factor: dict, raw) -> float:
        """Map a grader's entered value to [0,1] per the factor's manual_scale:
        'benchmark' (via benchmark_lo/hi + direction, like computed), 'percent'
        (0–100 ÷ 100), or 'normalized' (already in [0,1]). None → 0.0."""
        if raw is None:
            return 0.0
        scale = factor.get('manual_scale') or 'normalized'
        if scale == 'benchmark':
            return self._normalize(factor, raw)
        if scale == 'percent':
            return max(0.0, min(1.0, raw / 100.0))
        return max(0.0, min(1.0, raw))  # 'normalized'

    @staticmethod
    def _manual_norm_render(factor: dict, raw) -> dict:
        """Describe how a manual factor's value maps to [0,1], for the debug view."""
        scale = factor.get('manual_scale') or 'normalized'
        if scale == 'percent':
            expression = "clamp01(value / 100)"
            substituted = f"clamp01({_fmt_num(raw)} / 100)" if raw is not None else "no value yet"
        elif scale == 'benchmark':
            return {"scale": "benchmark",
                    **ScoringEngine._render_normalization(factor, raw, None)}
        else:
            expression = "clamp01(value)"
            substituted = f"clamp01({_fmt_num(raw)})" if raw is not None else "no value yet"
        return {"scale": scale, "expression": expression, "substituted": substituted}

    def grade(self, score_id: int, factor_id: int, value, comment: str | None = None) -> dict:
        """Record a grader's value (+ optional comment) for one manual factor,
        recompute the score total, and return the updated score. Validates that
        the score belongs to a manual model and the factor is part of that model."""
        score = self.db.scores.get_score(score_id)
        if score is None:
            raise ValueError(f"Score {score_id} not found")
        if score.get('scoring_mode') != 'manual':
            raise ValueError(
                f"Score {score_id} is for a computed model — grading applies to manual models")
        valid = {f['factor_id'] for f in self.db.scores.get_factors(score['model_version'])}
        if factor_id not in valid:
            raise ValueError(
                f"Factor {factor_id} is not part of model version {score['model_version']}")
        if value is not None and (isinstance(value, bool)
                                  or not isinstance(value, (int, float))
                                  or not math.isfinite(value)):
            raise ValueError(f"factor value must be a finite number, got: {value!r}")
        factor = self.db.scores.get_factor(factor_id)
        if factor is None:  # pragma: no cover — in `valid` but vanished (consistency)
            raise ValueError(f"Factor {factor_id} not found")
        weighted = self._normalize_manual(factor, value) * factor['weight']
        self.db.scores.grade_factor(score_id, factor_id, value, weighted, comment)
        self.db.scores.finalize_score(score_id, self.db.scores.sum_weighted(score_id))
        return self.db.scores.get_score(score_id)

    def _debug_manual(self, ein: str, year: int, filing: dict, model: dict,
                      factors: list[dict]) -> dict:
        """Walkthrough for a manual model: each factor's grading guidance and
        scale, plus the grader's value/comment and how it normalized — read from
        the stored score for this filing+model, if one has been graded."""
        version = model['version']
        graded: dict[int, dict] = {}
        total = None
        score_id = self.db.scores.get_score_id_for(ein, year, version)
        stored = self.db.scores.get_score(score_id) if score_id is not None else None
        if stored is not None:
            total = stored['total_score']
            graded = {f['factor_id']: f for f in stored['factors']}

        traces = []
        for f in factors:
            g = graded.get(f['factor_id'])
            raw = g['raw_value'] if g else None
            normalized = self._normalize_manual(f, raw)
            weighted = g['weighted_value'] if g and g['weighted_value'] is not None \
                else normalized * f['weight']
            traces.append({
                "factor_id":           f['factor_id'],
                "name":                f['name'],
                "kind":                "manual",
                "weight":              f['weight'],
                "manual_scale":        f.get('manual_scale') or 'normalized',
                "guidance":            f['formula_description'],
                "graded":              g is not None,
                "value":               raw,
                "comment":             g['comment'] if g else None,
                "normalization":       self._manual_norm_render(f, raw),
                "normalized":          normalized,
                "weighted_value":      weighted,
            })

        return {
            "ein": ein, "year": year, "filing_id": filing['filing_id'],
            "form_code": filing.get('form_code'), "model_version": version,
            "model_type": model.get('model_type'), "scoring_mode": "manual",
            "graded": stored is not None,
            "total_score": total if total is not None else 0.0,
            "factors": traces,
        }
