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
    # 990-PF (private foundation) concepts — foundations file a different return, so
    # they're scored by foundation-only models against these paths. The "charitable
    # disbursements" column (DsbrsChrtbl) is the qualifying-distributions view.
    'pf_charitable_disb': 'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesDsbrsChrtblAmt',
    'pf_grants_paid':     'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/ContriPaidDsbrsChrtblAmt',
    'pf_total_exp':       'ReturnData/IRS990PF/AnalysisOfRevenueAndExpenses/TotalExpensesRevAndExpnssAmt',
    'pf_total_assets':    'ReturnData/IRS990PF/Form990PFBalanceSheetsGrp/TotalAssetsEOYAmt',
    'pf_net_assets':      'ReturnData/IRS990PF/ChgInNetAssetsFundBalancesGrp/TotNetAstOrFundBalancesEOYAmt',
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

# The canonical financial concepts any scoring formula can read — the concept
# codes ARE the model input keys (== the _PATHS keys). Scoring reads the *chosen*
# (canonical) observation per (org, year, concept) from db.financials, which
# unifies 990, audited, OCR, and manual sources. _PATHS itself is retained for the
# 990→observation derivation and the debug source trace, not the scoring read.
_SCORING_CONCEPTS = frozenset(_PATHS.keys())

# Missing-data fallback strategies for a factor input when a year lacks its value.
# 'none' = no fill (the historical behavior); 'value:<x>' fills a constant.
_VALUE_PREFIX = 'value:'
MISSING_STRATEGIES = frozenset({'none', 'newest', 'oldest', 'closest_older', 'closest_newer'})


def valid_strategy(s) -> bool:
    """True for a known missing-data strategy token (incl. a parseable 'value:<x>')."""
    if s in MISSING_STRATEGIES:
        return True
    if isinstance(s, str) and s.startswith(_VALUE_PREFIX):
        try:
            float(s[len(_VALUE_PREFIX):])
            return True
        except ValueError:
            return False
    return False


def parse_inputs(inputs, model_default=None):
    """Split a factor's ``inputs`` (a JSON string or a list) into
    ``(keys, policies)``: ``keys[i]`` is the plain input string (concept code /
    ``model:<v>`` / ``factor:<name>`` / numeric literal) and ``policies[i]`` is the
    resolved missing-data strategy (an entry-level ``missing=`` override, else the
    model-level default, else ``'none'``). An ``inputs`` entry is either a bare
    string (no per-input policy) or a table ``{"key": ..., "missing": ...}``. Every
    legacy string-only consumer can call ``parse_inputs(...)[0]`` and keep operating
    on plain strings unchanged."""
    if isinstance(inputs, str):
        inputs = json.loads(inputs)
    default = model_default or 'none'
    keys, policies = [], []
    for entry in inputs:
        if isinstance(entry, dict):
            keys.append(entry.get('key'))
            policies.append(entry.get('missing') or default)
        else:
            keys.append(entry)
            policies.append(default)
    return keys, policies


def _pick_donor_year(series: dict, target_year: int, policy: str):
    """Choose the donor year from ``series`` ({year: value}) for a missing
    ``target_year`` per ``policy``: newest / oldest / closest_older / closest_newer
    (absolute-nearest, ties → older / newer respectively). Returns None for an
    empty series."""
    years = list(series)
    if not years:
        return None
    if policy == 'newest':
        return max(years)
    if policy == 'oldest':
        return min(years)
    older_first = policy != 'closest_newer'  # closest_older (and any default) → older
    return min(years, key=lambda y: (abs(y - target_year), y if older_first else -y))


class _FillCtx:
    """Per-model missing-data fill context for one target year. ``factor_imputed`` /
    ``factor_source_year`` are scratch written by ``_compute_factor`` and read back
    by ``_score_model_for_filing`` immediately after each factor."""
    __slots__ = ('concept_series', 'model_series', 'target_year', 'model_default',
                 'factor_imputed', 'factor_source_year')

    def __init__(self, concept_series, model_series, target_year, model_default):
        self.concept_series = concept_series
        self.model_series = model_series
        self.target_year = target_year
        self.model_default = model_default
        self.factor_imputed = False
        self.factor_source_year = None


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

    def calculate(self, ein: str, year: int, model_version: str = "1") -> dict:
        filing = self.db.filings.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        # Ensure this org's 990 values are mirrored into the canonical layer
        # (idempotent), then read the chosen concept values from there.
        self.db.financials.derive_from_990(ein)
        # Read the chosen (canonical) financial concepts for this org-year — the
        # unified value across 990/audited/OCR/manual sources — not raw 990 fields.
        vals = self.db.financials.get_year_canonical_values(ein, year)
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
            self.db.financials.get_historical_values(ein) if needs_history else {}

        # Apply missing-data fallbacks when the target model — or any model in its
        # dependency chain — declares a policy, so an incomplete year is filled
        # exactly as the batch path would (no calculate()/rebuild drift). When
        # nothing has a policy this is the unchanged, byte-identical code path.
        target_default = model.get('missing_data') if model else None
        target_has = (isinstance(target_default, str) and target_default not in ('', 'none')) or any(
            p != 'none' for f in sorted_factors for p in parse_inputs(f['inputs'])[1])
        needs_fill = target_has or (is_composite and any(
            self._model_has_policy(v)[0] for v in self._dependency_order(model_version)))
        if needs_fill:
            s = self._build_org_series(ein)
            vals = s['year_vals'].get(year, vals)
            concept_series = s['concept_series']
            if needs_history:
                historical = s['historical']
            model_totals = (self._compute_dependency_totals(
                model_version, vals, historical,
                concept_series=concept_series, target_year=year) if is_composite else {})
            target_fill = _FillCtx(concept_series, {}, year, target_default) if target_has else None
            total, factor_list = self._score_model_for_filing(
                sorted_factors, vals, historical, model_totals, fill=target_fill)
        else:
            model_totals = (self._compute_dependency_totals(model_version, vals, historical)
                            if is_composite else {})
            total, factor_list = self._score_model_for_filing(
                sorted_factors, vals, historical, model_totals)

        # Per-factor (raw, weighted) as before; the score-level `imputed` flag marks
        # whether any input was filled. (Per-factor donor years are recorded by the
        # batch path / history, not this single-score on-demand path.)
        score_imputed = any(len(fr) > 3 and fr[3] for fr in factor_list)
        factor_results = {fr[0]: (fr[1], fr[2]) for fr in factor_list}

        score_id = self.db.scores.create_score(filing['filing_id'], model_version)
        self.db.scores.store_factor_values(score_id, factor_results)
        self.db.scores.finalize_score(score_id, total, imputed=score_imputed)

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
            # Versions are strings; coerce requested versions so callers passing
            # ints (e.g. rebuild(model_versions=[10])) still match.
            requested = {str(v) for v in model_versions}
            want: set[str] = set()
            stack = [v for v in requested if v in by_version]
            while stack:
                v = stack.pop()
                if v in want:
                    continue
                want.add(v)
                for dep in self._model_refs(self.db.scores.get_factors(v)):
                    if dep in by_version and dep not in want:
                        stack.append(dep)
            computed = [m for m in computed if m['version'] in want]
        prepared_by_version: dict[str, dict] = {}
        for m in computed:
            factors = self.db.scores.get_factors(m['version'])
            if not factors:
                continue
            sorted_factors = self._topo_sort(factors)
            model_default = m.get('missing_data')
            has_policy = bool(model_default and model_default != 'none') or any(
                p != 'none' for f in sorted_factors for p in parse_inputs(f['inputs'])[1])
            prepared_by_version[m['version']] = {
                "version":       m['version'],
                "model_id":      m['model_id'],
                "kind":          m.get('model_kind', 'model'),
                "factors":       sorted_factors,
                "needs_history": any(f['formula_type'] in _HISTORICAL_TYPES for f in sorted_factors),
                "deps":          self._model_refs(sorted_factors),
                "missing_data":  model_default,
                "has_policy":    has_policy,
                "applies_to":    m.get('applies_to', 'both'),
            }
        return [prepared_by_version[v] for v in self._order_versions(prepared_by_version)]

    def _build_org_series(self, ein: str, scoring_concepts=_SCORING_CONCEPTS) -> dict:
        """Load an org's per-year canonical concept values + flat real historical,
        and derive the {concept: {year: value}} series the fill logic indexes.
        ``year_to_fid`` maps each real year to its representative integer filing_id
        (filings are ordered real-before-FIN, so the first per year wins); the
        score row stores that integer directly."""
        filings, vals_by_fid, historical = \
            self.db.financials.get_org_scoring_data(ein, scoring_concepts)
        year_to_fid: dict[int, int] = {}
        year_vals: dict[int, dict[str, float]] = {}
        for fil in filings:
            y = fil['year']
            year_to_fid.setdefault(y, fil['filing_id'])
            year_vals.setdefault(y, vals_by_fid.get(fil['filing_id'], {}))
        concept_series: dict[str, dict[int, float]] = {}
        for y, vals in year_vals.items():
            for c, v in vals.items():
                concept_series.setdefault(c, {})[y] = v
        return {"filings": filings, "vals_by_fid": vals_by_fid, "historical": historical,
                "year_vals": year_vals, "year_to_fid": year_to_fid,
                "concept_series": concept_series, "real_years": sorted(year_vals)}

    @staticmethod
    def _model_applies(applies_to: str, org_type: str | None) -> bool:
        """Whether a model with this ``applies_to`` scopes to an org of ``org_type``.
        'foundation' → only 990-PF foundations; 'nonprofit' → everything that is NOT
        a foundation (nonprofit / other / unclassified); 'both' (or None) → all."""
        if applies_to == 'foundation':
            return org_type == 'foundation'
        if applies_to == 'nonprofit':
            return org_type != 'foundation'
        return True

    def score_org(self, ein: str, prepared_models: list[dict],
                  scoring_concepts=_SCORING_CONCEPTS, org_type: str | None = None) -> int:
        """(Re)compute and store every prepared model's score for one org in a
        single bulk replace (no commit — the caller batches). Returns the number of
        scores written.

        Two scoring shapes share a per-year ``model_series`` ({version: {year:
        total}}) so composites/super-composites read child totals by year:

        * **No missing-data policy** (every existing model): scored exactly as
          before — one row per real *filing* (so a multi-filing year keeps its rows),
          byte-identical totals. The equality invariant rests on this branch.
        * **Has a policy**: scored once per year across ``[earliest .. latest]`` of
          the org's real data, imputing missing inputs per their strategy; a fully
          missing interior year gets a synthetic FIN anchor. Imputed rows/factors
          are flagged with the donor year."""
        if not prepared_models:
            return 0
        # Scope to the models that apply to this org's type — foundations and
        # nonprofits are scored by different models. We still DELETE the org's scores
        # for every prepared model (all_ids) so a now-inapplicable model's stale
        # scores are removed, but only INSERT results for applicable models.
        all_ids = [m['model_id'] for m in prepared_models]
        applicable = [m for m in prepared_models
                      if self._model_applies(m.get('applies_to', 'both'), org_type)]
        if not applicable:
            self.db.scores.replace_org_scores(ein, all_ids, [])
            return 0
        # NOTE: 990 values are mirrored into the canonical layer by the caller in
        # BULK (rebuild() runs db.financials.derive_bulk once up front) — a set-based
        # pass that replaced the old per-org derive_from_990 here, which profiling
        # showed was ~98% of rebuild time. The single-filing calculate()/debug()
        # paths still self-derive per org.
        s = self._build_org_series(ein, scoring_concepts)
        if not s['real_years']:
            return 0
        min_y, max_y = s['real_years'][0], s['real_years'][-1]
        model_series: dict[str, dict[int, float | None]] = {}
        # {version: {years that were imputed}} — so a composite/super-composite that
        # reads an imputed child total (a present-but-filled value) is itself flagged
        # imputed, propagating the estimate up the chain.
        imputed_years: dict[str, set] = {}
        results = []
        for m in applicable:
            hist = s['historical'] if m['needs_history'] else {}
            ms = model_series.setdefault(m['version'], {})
            if not m['has_policy']:
                # Exact pre-feature path: one row per real filing.
                for fil in s['filings']:
                    fid, year = fil['filing_id'], fil['year']
                    model_totals = {v: model_series.get(v, {}).get(year) for v in m['deps']}
                    total, factor_results = self._score_model_for_filing(
                        m['factors'], s['vals_by_fid'].get(fid, {}), hist, model_totals)
                    ms[year] = total
                    results.append((fid, m['model_id'], total, factor_results))
            else:
                # Fill path: one row per year in the org's data span.
                for year in range(min_y, max_y + 1):
                    model_totals = {v: model_series.get(v, {}).get(year) for v in m['deps']}
                    fill = _FillCtx(s['concept_series'], model_series, year, m['missing_data'])
                    total, factor_results = self._score_model_for_filing(
                        m['factors'], s['year_vals'].get(year, {}), hist, model_totals, fill=fill)
                    ms[year] = total
                    imputed = any(fr[3] for fr in factor_results) or \
                        any(year in imputed_years.get(v, ()) for v in m['deps'])
                    if imputed:
                        imputed_years.setdefault(m['version'], set()).add(year)
                    fid = s['year_to_fid'].get(year) or \
                        self.db.financials.ensure_year_anchor_filing_id(ein, year)
                    results.append((fid, m['model_id'], total, factor_results, imputed))
        self.db.scores.replace_org_scores(ein, all_ids, results)
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
        full = eins is None
        eins = self.db.scores.all_eins() if full else list(eins)
        # Mirror 990 → canonical financials before the scoring loop (replaces the old
        # per-org derive inside score_org). A full corpus or a large touched-set (a big
        # ingest) derives the WHOLE corpus in sequential filing-id batches — random
        # per-org IO is far slower at scale, and deriving extra orgs is idempotent. A
        # small set (score --org, a tiny ingest) scopes by org.
        self.db.financials.derive_bulk(None if (full or len(eins) > 2000) else eins,
                                       commit=False)
        # Each org is scored only by the models that apply to its type (foundations
        # vs nonprofits) — one cheap {ein: org_type} lookup drives the per-org filter.
        org_types = self.db.orgs.org_type_map(None if full else eins)
        total = len(eins)
        scores = 0
        for i, ein in enumerate(eins, 1):
            scores += self.score_org(ein, prepared, org_type=org_types.get(ein))
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
            for inp in parse_inputs(name_to_factor[name]['inputs'])[0]:
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
    def _model_refs(factors: list[dict]) -> set[str]:
        """The model:<version> versions referenced across a model's factors — the
        other models a composite/super-composite depends on. Versions are opaque
        strings (e.g. '10', '1.1')."""
        refs: set[str] = set()
        for f in factors:
            for inp in parse_inputs(f['inputs'])[0]:
                if isinstance(inp, str) and inp.startswith(_MODEL_PREFIX):
                    ref = inp[len(_MODEL_PREFIX):]
                    if ref:
                        refs.add(ref)
        return refs

    def _score_model_for_filing(self, factors: list[dict], vals: dict[str, float],
                                historical: dict[str, list[float]],
                                model_totals: dict[str, float | None], *, fill=None):
        """Evaluate one model's (topo-sorted) factors against a single filing/year.
        Returns ``(total_score, factor_results)``. Without ``fill`` each factor
        result is ``(factor_id, raw, weighted)`` (the historical behavior); with a
        ``_FillCtx`` it is ``(factor_id, raw, weighted, imputed, source_year)`` and
        missing inputs are filled from other years per their policy. ``model_totals``
        is the ``{version: total}`` of already-scored models for this year (for
        ``model:<version>`` inputs); pass ``{}`` for a base model. Shared primitive
        behind both calculate() and the batch path."""
        computed: dict[str, float | None] = {}
        factor_results: list = []
        total = 0.0
        for f in factors:
            raw = self._compute_factor(f, vals, computed, historical, model_totals, fill=fill)
            computed[f['name']] = raw
            weighted = self._normalize(f, raw) * f['weight']
            total += weighted
            if fill is None:
                factor_results.append((f['factor_id'], raw, weighted))
            else:
                factor_results.append((f['factor_id'], raw, weighted,
                                       fill.factor_imputed, fill.factor_source_year))
        return total, factor_results

    @staticmethod
    def _order_versions(prepared: dict[str, dict]) -> list[str]:
        """Topologically order prepared model versions so a model's ``model:<v>``
        dependencies score before it. Deps on versions not in ``prepared`` (manual,
        factorless, or outside a requested subset) are skipped for ordering — they
        resolve to None at score time. Raises on a dependency cycle."""
        order: list[str] = []
        visited: set[str] = set()
        in_stack: set[str] = set()

        def visit(v: str) -> None:
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

    def _dependency_order(self, target_version: str) -> list[str]:
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
        order: list[str] = []
        visited: set[str] = set()
        in_stack: set[str] = set()

        def visit(v: str, is_target: bool) -> None:
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

    def _model_has_policy(self, version: int):
        """``(has_policy, model_default)`` for a model version: whether any factor
        input (or the model-level default) carries a non-``none`` missing-data
        strategy, and the model-level default itself."""
        model = self.db.scores.get_model(version)
        default = (model or {}).get('missing_data')
        if isinstance(default, str) and default and default != 'none':
            return True, default
        factors = self.db.scores.get_factors(version)
        has = any(p != 'none' for f in factors for p in parse_inputs(f['inputs'])[1])
        return has, default

    def _compute_dependency_totals(self, target_version: str, vals: dict[str, float],
                                   historical: dict[str, list[float]], *,
                                   concept_series=None, target_year=None) -> dict[str, float | None]:
        """Score every model ``target_version`` depends on for a single year,
        returning ``{version: total}`` — the model_totals a composite's factors read.
        When ``concept_series`` is given, each child with a missing-data policy fills
        its own missing inputs for ``target_year`` (so calculate() matches the batch
        path for an incomplete year); otherwise children score from real values only."""
        totals: dict[str, float | None] = {}
        for v in self._dependency_order(target_version):
            factors = self._topo_sort(self.db.scores.get_factors(v))
            fill = None
            if concept_series is not None:
                has, default = self._model_has_policy(v)
                if has:
                    fill = _FillCtx(concept_series, {}, target_year, default)
            total, _ = self._score_model_for_filing(factors, vals, historical, totals, fill=fill)
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
                       model_totals: dict[str, float | None] | None = None) -> float | None:
        if key.startswith(_FACTOR_PREFIX):
            return computed.get(key[len(_FACTOR_PREFIX):])
        if key.startswith(_MODEL_PREFIX):
            ref = key[len(_MODEL_PREFIX):]
            return (model_totals or {}).get(ref)
        try:
            return float(key)
        except (ValueError, TypeError):
            pass
        # vals is keyed by canonical concept code (== the model input key).
        return vals.get(key)

    def _resolve_input_filled(self, key, policy, vals, computed, model_totals, fill):
        """Resolve one input, applying its missing-data ``policy`` when the real
        value for the target year is absent. Returns ``(value, source_year,
        imputed)`` — ``source_year`` is the donor year (None for a constant fill or
        no fill). Only concept and ``model:<v>`` inputs are series-fillable; a
        ``factor:`` ref or numeric literal is never filled (it resolves in-year)."""
        real = self._resolve_input(key, vals, computed, model_totals)
        if real is not None or policy == 'none':
            return real, None, False
        if isinstance(policy, str) and policy.startswith(_VALUE_PREFIX):
            try:
                return float(policy[len(_VALUE_PREFIX):]), None, True
            except ValueError:
                return None, None, False
        series = None
        if isinstance(key, str) and key.startswith(_MODEL_PREFIX):
            series = fill.model_series.get(key[len(_MODEL_PREFIX):])
        elif isinstance(key, str) and not key.startswith(_FACTOR_PREFIX):
            series = fill.concept_series.get(key)
        if not series:
            return None, None, False
        # series is non-empty here, so _pick_donor_year always returns a year.
        donor = _pick_donor_year(series, fill.target_year, policy)
        return series[donor], donor, True

    def _compute_factor(self, factor: dict, vals: dict[str, float],
                        computed: dict[str, float | None] | None = None,
                        historical: dict[str, list[float]] | None = None,
                        model_totals: dict[str, float | None] | None = None,
                        *, fill: '_FillCtx | None' = None) -> float | None:
        if computed is None:
            computed = {}
        if historical is None:
            historical = {}
        formula_type = factor['formula_type']
        keys, policies = parse_inputs(factor['inputs'],
                                      fill.model_default if fill is not None else None)
        if fill is not None:
            # Reset per-factor scratch BEFORE the historical short-circuit so a
            # historical factor (which never fills) clears a prior factor's flag.
            fill.factor_imputed = False
            fill.factor_source_year = None

        # --- Historical formulas ---
        if formula_type in _HISTORICAL_TYPES:
            # historical is keyed by concept code (the model input key).
            concept = keys[0] if keys else None
            hist = historical.get(concept, []) if concept else []
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

        if fill is None:
            inputs = [self._resolve_input(k, vals, computed, model_totals) for k in keys]
        else:
            inputs = []
            for k, pol in zip(keys, policies):
                v, sy, imp = self._resolve_input_filled(k, pol, vals, computed, model_totals, fill)
                inputs.append(v)
                if imp:
                    fill.factor_imputed = True
                    if sy is not None and fill.factor_source_year is None:
                        fill.factor_source_year = sy

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

    def debug(self, ein: str, year: int, model_version: str = "1") -> dict:
        filing = self.db.filings.get_filing_data_by_ein_year(ein, year)
        if filing is None:
            raise ValueError(f"No filing found for EIN {ein} year {year}")

        self.db.financials.derive_from_990(ein)   # idempotent; keeps the trace accurate
        fields = filing['fields']
        raw_by_path = {f['xml_path']: f.get('value')
                       for f in fields if f.get('xml_path')}
        # Scoring reads the chosen (canonical) concept values; provenance carries
        # the source/confidence/conflict for each concept so the trace shows where
        # the chosen value came from.
        vals = self.db.financials.get_year_canonical_values(ein, year)
        provenance = {f['concept_code']: f
                      for f in self.db.financials.get_org_financials(ein, year)['facts']}

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
        historical = self.db.financials.get_historical_values(ein) if needs_history else {}

        # Mirror calculate()/score_org: when the model (or its chain) declares a
        # missing-data policy, fill the trace's inputs from other years so the
        # walkthrough matches the stored, filled score.
        target_default = model.get('missing_data') if model else None
        target_has = (isinstance(target_default, str) and target_default not in ('', 'none')) or any(
            p != 'none' for f in sorted_factors for p in parse_inputs(f['inputs'])[1])
        needs_fill = target_has or (is_composite and any(
            self._model_has_policy(v)[0] for v in self._dependency_order(model_version)))
        fill = None
        if needs_fill:
            series = self._build_org_series(ein)
            vals = series['year_vals'].get(year, vals)
            if needs_history:
                historical = series['historical']
            model_totals = (self._compute_dependency_totals(
                model_version, vals, historical,
                concept_series=series['concept_series'], target_year=year) if is_composite else {})
            if target_has:
                fill = _FillCtx(series['concept_series'], {}, year, target_default)
        else:
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
            raw = self._compute_factor(f, vals, computed, historical, model_totals, fill=fill)
            computed[f['name']] = raw
            normalized = self._normalize(f, raw)
            weighted = normalized * f['weight']
            total += weighted
            trace = self._debug_factor(
                f, vals, raw_by_path, computed, historical, model_totals, source_for,
                raw, normalized, weighted, provenance)
            if fill is not None:
                trace['imputed'] = fill.factor_imputed
                trace['source_year'] = fill.factor_source_year
            traces.append(trace)

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
                      model_totals, source_for, raw, normalized, weighted,
                      provenance=None) -> dict:
        ftype = factor['formula_type']
        keys = parse_inputs(factor['inputs'])[0]
        is_hist = ftype in _HISTORICAL_TYPES

        variables = [
            self._describe_variable(k, vals, raw_by_path, computed, historical,
                                    model_totals, source_for, is_hist, provenance)
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
                           model_totals, source_for, is_hist: bool, provenance=None) -> dict:
        if key.startswith(_FACTOR_PREFIX):
            name = key[len(_FACTOR_PREFIX):]
            return {"key": key, "kind": "factor", "references": name,
                    "value": computed.get(name)}
        if key.startswith(_MODEL_PREFIX):
            version = key[len(_MODEL_PREFIX):] or None
            return {"key": key, "kind": "model", "references": version,
                    "value": (model_totals or {}).get(version) if version is not None else None}
        try:
            return {"key": key, "kind": "literal", "value": float(key)}
        except (ValueError, TypeError):
            pass
        # A canonical financial concept. Show the chosen value + its provenance
        # (source / confidence / whether sources disagree), and — for 990-derived
        # concepts — the originating form/part/line via the xml_path.
        path = _PATHS.get(key)
        prov = (provenance or {}).get(key) or {}
        chosen = next((o for o in prov.get("observations", []) if o.get("is_canonical")), {})
        var = {
            "key":         key,
            "kind":        "concept",
            "concept":     key,
            "xml_path":    path,
            "value":       vals.get(key),
            "raw_value":   raw_by_path.get(path) if path else None,
            "present":     key in vals,
            "source":      source_for(path) if path else None,
            "canonical_source": chosen.get("source_code"),
            "confidence":  chosen.get("confidence"),
            "conflict":    prov.get("conflict", False),
        }
        if is_hist:
            var["series"] = historical.get(key, [])
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
        graded: dict[str, dict] = {}
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
