import io
import json
import os
import sys
import tempfile
import unittest
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from models import validate_toml, cmd_register, cmd_list


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _valid_model(version=2, description=None) -> dict:
    m = {'version': version}
    if description:
        m['description'] = description
    return m


def _valid_factor(name='Test Factor', weight=1.0, formula_type='ratio',
                  inputs=None, direction='higher',
                  benchmark_lo=0.0, benchmark_hi=1.0,
                  formula_description=None) -> dict:
    f = {
        'name': name,
        'weight': weight,
        'formula_type': formula_type,
        'inputs': inputs or ['prog', 'total_exp'],
        'direction': direction,
        'benchmark_lo': benchmark_lo,
        'benchmark_hi': benchmark_hi,
    }
    if formula_description:
        f['formula_description'] = formula_description
    return f


def _valid_toml(**kwargs) -> dict:
    return {
        'model': _valid_model(**kwargs),
        'factor': [_valid_factor()],
    }


def _errors(data: dict) -> list[str]:
    return [i for i in validate_toml(data) if i.startswith('ERROR:')]


def _warnings(data: dict) -> list[str]:
    return [i for i in validate_toml(data) if i.startswith('WARNING:')]


# ---------------------------------------------------------------------------
# validate_toml — clean data produces no issues
# ---------------------------------------------------------------------------

class TestValidateTomlClean(unittest.TestCase):

    def test_valid_minimal_produces_no_errors(self):
        self.assertEqual(_errors(_valid_toml()), [])

    def test_valid_minimal_produces_no_warnings(self):
        self.assertEqual(_warnings(_valid_toml()), [])

    def test_valid_with_description(self):
        data = _valid_toml()
        data['model']['description'] = 'A description'
        self.assertEqual(_errors(data), [])

    def test_valid_multiple_factors(self):
        data = {
            'model': _valid_model(),
            'factor': [
                _valid_factor('Factor A', weight=0.5),
                _valid_factor('Factor B', weight=0.5),
            ],
        }
        self.assertEqual(_errors(data), [])

    def test_weights_summing_to_1_produces_no_warning(self):
        data = {
            'model': _valid_model(),
            'factor': [
                _valid_factor('A', weight=0.5),
                _valid_factor('B', weight=0.5),
            ],
        }
        self.assertEqual(_warnings(data), [])

    def test_all_formula_types_accepted(self):
        from models import FORMULA_TYPES, FORMULA_INPUT_COUNTS
        for ft in FORMULA_TYPES:
            n = FORMULA_INPUT_COUNTS[ft]
            all_keys = ['prog', 'admin', 'fund', 'total_exp',
                        'cy_exp', 'cy_rev', 'contrib', 'liabilities']
            # None = variable-length: use 2 inputs; integer = exact count
            inputs = all_keys[:2] if n is None else all_keys[:n]
            data = {
                'model': _valid_model(),
                'factor': [_valid_factor(formula_type=ft, inputs=inputs)],
            }
            errs = _errors(data)
            self.assertEqual(errs, [], msg=f"Unexpected errors for formula_type={ft!r}: {errs}")


# ---------------------------------------------------------------------------
# validate_toml — unknown top-level keys
# ---------------------------------------------------------------------------

class TestValidateTomlUnknownTopLevel(unittest.TestCase):

    def test_unknown_top_level_key_is_error(self):
        data = _valid_toml()
        data['extra'] = 'oops'
        self.assertTrue(any('extra' in e for e in _errors(data)))

    def test_known_top_level_keys_not_flagged(self):
        data = _valid_toml()
        errs = _errors(data)
        self.assertFalse(any("'model'" in e for e in errs))
        self.assertFalse(any("'factor'" in e for e in errs))


# ---------------------------------------------------------------------------
# validate_toml — [model] section
# ---------------------------------------------------------------------------

class TestValidateTomlModelEdgeCases(unittest.TestCase):
    """Branch coverage for unusual but valid Python inputs to validate_toml."""

    def test_model_not_a_dict_is_error(self):
        data = {'model': 'not a dict', 'factor': [_valid_factor()]}
        self.assertTrue(any('must be a table' in e for e in _errors(data)))

    def test_factors_not_a_list_is_error(self):
        data = {'model': _valid_model(), 'factor': 'not a list'}
        self.assertTrue(any('array' in e.lower() for e in _errors(data)))

    def test_factor_entry_not_a_dict_is_error(self):
        data = {'model': _valid_model(), 'factor': ['not-a-dict']}
        self.assertTrue(any('must be a table' in e.lower() for e in _errors(data)))

    def test_benchmark_lo_not_a_number_is_error(self):
        f = _valid_factor()
        f['benchmark_lo'] = 'bad'
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('benchmark_lo' in e for e in _errors(data)))

    def test_benchmark_hi_not_a_number_is_error(self):
        f = _valid_factor()
        f['benchmark_lo'] = 0.1       # lo is a number
        f['benchmark_hi'] = 'bad'     # hi is not → hits the elif branch
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('benchmark_hi' in e for e in _errors(data)))


class TestValidateTomlModel(unittest.TestCase):

    def test_missing_model_section_is_error(self):
        data = {'factor': [_valid_factor()]}
        self.assertTrue(any('model' in e for e in _errors(data)))

    def test_model_version_required(self):
        data = {'model': {}, 'factor': [_valid_factor()]}
        errs = _errors(data)
        self.assertTrue(any('version' in e for e in errs))

    def test_model_version_zero_is_error(self):
        data = _valid_toml()
        data['model']['version'] = 0
        self.assertTrue(any('version' in e for e in _errors(data)))

    def test_model_version_negative_is_error(self):
        data = _valid_toml()
        data['model']['version'] = -1
        self.assertTrue(any('version' in e for e in _errors(data)))

    def test_model_version_float_is_error(self):
        data = _valid_toml()
        data['model']['version'] = 1.5
        self.assertTrue(any('version' in e for e in _errors(data)))

    def test_model_version_string_is_error(self):
        data = _valid_toml()
        data['model']['version'] = 'two'
        self.assertTrue(any('version' in e for e in _errors(data)))

    def test_model_unknown_key_is_error(self):
        data = _valid_toml()
        data['model']['extra'] = 'oops'
        self.assertTrue(any('extra' in e for e in _errors(data)))

    def test_model_description_accepted(self):
        data = _valid_toml()
        data['model']['description'] = 'Optional desc'
        self.assertEqual(_errors(data), [])

    def test_model_positive_version_accepted(self):
        data = _valid_toml(version=42)
        self.assertEqual(_errors(data), [])


# ---------------------------------------------------------------------------
# validate_toml — [[factor]] list
# ---------------------------------------------------------------------------

class TestValidateTomlFactors(unittest.TestCase):

    def test_empty_factor_list_is_error(self):
        data = {'model': _valid_model(), 'factor': []}
        self.assertTrue(any('factor' in e.lower() or 'required' in e.lower() for e in _errors(data)))

    def test_missing_factor_section_is_error(self):
        data = {'model': _valid_model()}
        self.assertTrue(_errors(data))

    def test_duplicate_factor_name_is_error(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor('Same'), _valid_factor('Same')],
        }
        self.assertTrue(any('duplicate' in e.lower() for e in _errors(data)))

    def test_unique_factor_names_accepted(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor('A', weight=0.5), _valid_factor('B', weight=0.5)],
        }
        self.assertEqual(_errors(data), [])

    def test_factor_unknown_key_is_error(self):
        f = _valid_factor()
        f['mystery'] = 'value'
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('mystery' in e for e in _errors(data)))

    def test_factor_optional_formula_description_accepted(self):
        f = _valid_factor(formula_description='desc')
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertEqual(_errors(data), [])

    # Required fields

    def test_missing_name_is_error(self):
        f = _valid_factor()
        del f['name']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('name' in e for e in _errors(data)))

    def test_missing_weight_is_error(self):
        f = _valid_factor()
        del f['weight']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('weight' in e for e in _errors(data)))

    def test_missing_formula_type_is_error(self):
        f = _valid_factor()
        del f['formula_type']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('formula_type' in e for e in _errors(data)))

    def test_missing_inputs_is_error(self):
        f = _valid_factor()
        del f['inputs']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('inputs' in e for e in _errors(data)))

    def test_missing_direction_is_error(self):
        f = _valid_factor()
        del f['direction']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('direction' in e for e in _errors(data)))

    def test_missing_benchmark_lo_is_error(self):
        f = _valid_factor()
        del f['benchmark_lo']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('benchmark_lo' in e for e in _errors(data)))

    def test_missing_benchmark_hi_is_error(self):
        f = _valid_factor()
        del f['benchmark_hi']
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('benchmark_hi' in e for e in _errors(data)))


# ---------------------------------------------------------------------------
# validate_toml — weight validation
# ---------------------------------------------------------------------------

class TestValidateTomlWeight(unittest.TestCase):

    def test_zero_weight_accepted(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor('Intermediate', weight=0), _valid_factor('Final', weight=1.0)],
        }
        self.assertFalse(any('weight' in e for e in _errors(data)))

    def test_negative_weight_is_error(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(weight=-0.1)]}
        self.assertTrue(any('weight' in e for e in _errors(data)))

    def test_positive_weight_accepted(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(weight=0.05)]}
        self.assertEqual(_errors(data), [])

    def test_weights_not_summing_to_1_produces_warning(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(weight=0.5)]}
        self.assertTrue(any('WARNING' in w and 'weight' in w.lower() for w in _warnings(data)))

    def test_weights_summing_to_1_no_warning(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor('A', weight=0.3), _valid_factor('B', weight=0.7)],
        }
        self.assertEqual(_warnings(data), [])


# ---------------------------------------------------------------------------
# validate_toml — formula_type validation
# ---------------------------------------------------------------------------

class TestValidateTomlFormulaType(unittest.TestCase):

    def test_unknown_formula_type_is_error(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(formula_type='magic')]}
        self.assertTrue(any('formula_type' in e or 'magic' in e for e in _errors(data)))

    def test_known_formula_types_accepted(self):
        for ft in ('ratio', 'ratio_positive', 'growth'):
            data = {'model': _valid_model(), 'factor': [_valid_factor(formula_type=ft, inputs=['prog', 'total_exp'])]}
            self.assertFalse(any('formula_type' in e or 'unknown' in e for e in _errors(data)),
                             msg=f"Unexpected error for formula_type={ft!r}")


# ---------------------------------------------------------------------------
# validate_toml — inputs validation
# ---------------------------------------------------------------------------

class TestValidateTomlInputs(unittest.TestCase):

    def test_unknown_input_key_is_error(self):
        f = _valid_factor(inputs=['prog', 'unknown_key'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('unknown_key' in e for e in _errors(data)))

    def test_valid_input_keys_accepted(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(inputs=['prog', 'total_exp'])]}
        self.assertFalse(any('unknown input' in e.lower() for e in _errors(data)))

    def test_wrong_input_count_for_ratio_is_error(self):
        f = _valid_factor(formula_type='ratio', inputs=['prog', 'total_exp', 'cy_exp'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('inputs' in e or 'require' in e.lower() for e in _errors(data)))

    def test_wrong_input_count_for_working_capital_is_error(self):
        f = _valid_factor(formula_type='working_capital', inputs=['cash', 'savings'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('inputs' in e or 'require' in e.lower() for e in _errors(data)))

    def test_correct_input_count_for_sum_ratio(self):
        f = _valid_factor(formula_type='sum_ratio', inputs=['admin', 'fund', 'total_exp'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertFalse(any('require' in e.lower() for e in _errors(data)))

    def test_variable_formula_zero_inputs_is_error(self):
        for ft in ('sum', 'average', 'min', 'max'):
            f = {'name': ft, 'weight': 1.0, 'formula_type': ft, 'inputs': [],
                 'direction': 'higher', 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertTrue(_errors(data), msg=f"Expected error for {ft!r} with 0 inputs")

    def test_variable_formula_single_input_accepted(self):
        for ft in ('sum', 'average', 'min', 'max'):
            f = _valid_factor(formula_type=ft, inputs=['prog'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertFalse(
                any('require' in e.lower() for e in _errors(data)),
                msg=f"Unexpected count error for {ft!r}"
            )

    def test_variable_formula_many_inputs_accepted(self):
        for ft in ('sum', 'average', 'min', 'max'):
            f = _valid_factor(formula_type=ft, inputs=['prog', 'admin', 'fund', 'cy_rev'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertFalse(
                any('require' in e.lower() for e in _errors(data)),
                msg=f"Unexpected count error for {ft!r}"
            )

    def test_historical_formula_one_input_accepted(self):
        for ft in ('running_average', 'cumulative_sum', 'historical_min', 'historical_max'):
            f = _valid_factor(formula_type=ft, inputs=['cy_rev'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertFalse(
                any('require' in e.lower() for e in _errors(data)),
                msg=f"Unexpected error for {ft!r}"
            )

    def test_historical_formula_wrong_count_is_error(self):
        for ft in ('running_average', 'cumulative_sum', 'historical_min', 'historical_max'):
            f = _valid_factor(formula_type=ft, inputs=['cy_rev', 'cy_exp'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertTrue(
                any('require' in e.lower() or 'inputs' in e.lower() for e in _errors(data)),
                msg=f"Expected count error for {ft!r}"
            )

    def test_inputs_not_a_list_is_error(self):
        f = _valid_factor()
        f['inputs'] = 'not-a-list'
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('inputs' in e.lower() for e in _errors(data)))

    def test_factor_ref_to_existing_factor_accepted(self):
        data = {
            'model': _valid_model(),
            'factor': [
                _valid_factor('Upstream', weight=0),
                _valid_factor('Downstream', inputs=['factor:Upstream', 'total_exp'], weight=1.0),
            ],
        }
        self.assertEqual(_errors(data), [])

    def test_factor_ref_to_unknown_factor_is_error(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor(inputs=['factor:Ghost', 'total_exp'])],
        }
        self.assertTrue(any('Ghost' in e for e in _errors(data)))

    def test_factor_ref_empty_name_is_error(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor(inputs=['factor:', 'total_exp'])],
        }
        self.assertTrue(_errors(data))

    def test_factor_circular_dependency_is_error(self):
        data = {
            'model': _valid_model(),
            'factor': [
                _valid_factor('A', inputs=['factor:B', 'total_exp'], weight=0.5),
                _valid_factor('B', inputs=['factor:A', 'total_exp'], weight=0.5),
            ],
        }
        self.assertTrue(any('circular' in e.lower() for e in _errors(data)))

    def test_factor_self_reference_is_error(self):
        data = {
            'model': _valid_model(),
            'factor': [_valid_factor('Loop', inputs=['factor:Loop', 'total_exp'])],
        }
        self.assertTrue(any('circular' in e.lower() for e in _errors(data)))

    def test_non_string_non_path_input_is_error(self):
        # A bare integer in inputs (not a string numeric literal) hits the non-string branch
        f = _valid_factor(formula_type='ratio', inputs=[99999, 'total_exp'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('unknown input key' in e for e in _errors(data)))

    def test_numeric_literal_input_accepted(self):
        f = _valid_factor(formula_type='clamp', inputs=['cy_rev', '0', '1'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertEqual(_errors(data), [])

    def test_clamp_three_inputs_accepted(self):
        f = _valid_factor(formula_type='clamp', inputs=['cy_rev', 'cy_exp', 'prog'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertEqual(_errors(data), [])

    def test_clamp_wrong_count_is_error(self):
        f = _valid_factor(formula_type='clamp', inputs=['cy_rev', 'cy_exp'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(any('require' in e.lower() or 'inputs' in e.lower() for e in _errors(data)))

    def test_median_zero_inputs_is_error(self):
        f = {'name': 'M', 'weight': 1.0, 'formula_type': 'median', 'inputs': [],
             'direction': 'higher', 'benchmark_lo': 0.0, 'benchmark_hi': 1.0}
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertTrue(_errors(data))

    def test_median_single_input_accepted(self):
        f = _valid_factor(formula_type='median', inputs=['cy_rev'])
        data = {'model': _valid_model(), 'factor': [f]}
        self.assertFalse(any('require' in e.lower() for e in _errors(data)))

    def test_new_historical_formulas_one_input_accepted(self):
        for ft in ('cagr', 'historical_std_dev', 'coefficient_of_variation'):
            f = _valid_factor(formula_type=ft, inputs=['cy_rev'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertFalse(
                any('require' in e.lower() for e in _errors(data)),
                msg=f"Unexpected error for {ft!r}"
            )

    def test_new_historical_formulas_wrong_count_is_error(self):
        for ft in ('cagr', 'historical_std_dev', 'coefficient_of_variation'):
            f = _valid_factor(formula_type=ft, inputs=['cy_rev', 'cy_exp'])
            data = {'model': _valid_model(), 'factor': [f]}
            self.assertTrue(
                any('require' in e.lower() or 'inputs' in e.lower() for e in _errors(data)),
                msg=f"Expected count error for {ft!r}"
            )


# ---------------------------------------------------------------------------
# validate_toml — direction validation
# ---------------------------------------------------------------------------

class TestValidateTomlDirection(unittest.TestCase):

    def test_invalid_direction_is_error(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(direction='sideways')]}
        self.assertTrue(any('direction' in e for e in _errors(data)))

    def test_higher_direction_accepted(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(direction='higher')]}
        self.assertFalse(any('direction' in e for e in _errors(data)))

    def test_lower_direction_accepted(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(direction='lower')]}
        self.assertFalse(any('direction' in e for e in _errors(data)))


# ---------------------------------------------------------------------------
# validate_toml — benchmark validation
# ---------------------------------------------------------------------------

class TestValidateTomlBenchmarks(unittest.TestCase):

    def test_lo_equal_to_hi_is_error(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(benchmark_lo=0.5, benchmark_hi=0.5)]}
        self.assertTrue(any('benchmark' in e.lower() for e in _errors(data)))

    def test_lo_greater_than_hi_is_error(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(benchmark_lo=0.8, benchmark_hi=0.2)]}
        self.assertTrue(any('benchmark' in e.lower() for e in _errors(data)))

    def test_negative_lo_accepted_when_lo_less_than_hi(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(benchmark_lo=-0.2, benchmark_hi=0.2)]}
        self.assertFalse(any('benchmark' in e.lower() for e in _errors(data)))

    def test_lo_less_than_hi_accepted(self):
        data = {'model': _valid_model(), 'factor': [_valid_factor(benchmark_lo=0.1, benchmark_hi=0.9)]}
        self.assertFalse(any('benchmark' in e.lower() for e in _errors(data)))


# ---------------------------------------------------------------------------
# cmd_register — dry run
# ---------------------------------------------------------------------------

class TestCmdRegisterDryRun(unittest.TestCase):

    def _write_toml(self, data: dict, tmp_dir: str) -> str:
        import tomllib
        # Write TOML manually since tomllib is read-only; construct minimal TOML text
        lines = [f'[model]', f'version = {data["model"]["version"]}']
        if 'description' in data.get('model', {}):
            lines.append(f'description = "{data["model"]["description"]}"')
        for f in data.get('factor', []):
            lines.append('')
            lines.append('[[factor]]')
            lines.append(f'name = "{f["name"]}"')
            lines.append(f'weight = {f["weight"]}')
            lines.append(f'formula_type = "{f["formula_type"]}"')
            inputs_str = '[' + ', '.join(f'"{i}"' for i in f['inputs']) + ']'
            lines.append(f'inputs = {inputs_str}')
            lines.append(f'direction = "{f["direction"]}"')
            lines.append(f'benchmark_lo = {f["benchmark_lo"]}')
            lines.append(f'benchmark_hi = {f["benchmark_hi"]}')
        path = os.path.join(tmp_dir, 'model.toml')
        with open(path, 'w') as fh:
            fh.write('\n'.join(lines))
        return path

    def setUp(self):
        self._tmp = tempfile.mkdtemp()

    def tearDown(self):
        import shutil
        shutil.rmtree(self._tmp, ignore_errors=True)

    def _args(self, path, dry_run=True, db=None, skip_existing=False):
        args = MagicMock()
        args.file = path
        args.dry_run = dry_run
        args.skip_existing = skip_existing
        args.db = db
        return args

    def test_dry_run_prints_success(self):
        path = self._write_toml(_valid_toml(version=2), self._tmp)
        args = self._args(path)
        with patch('builtins.print') as mock_print:
            cmd_register(args)
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('Validation passed', output)

    def test_dry_run_includes_version(self):
        path = self._write_toml(_valid_toml(version=99), self._tmp)
        args = self._args(path)
        with patch('builtins.print') as mock_print:
            cmd_register(args)
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('99', output)

    def test_dry_run_includes_factor_count(self):
        data = {'model': _valid_model(version=2), 'factor': [_valid_factor()]}
        path = self._write_toml(data, self._tmp)
        args = self._args(path)
        with patch('builtins.print') as mock_print:
            cmd_register(args)
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('1', output)

    def test_dry_run_does_not_call_database(self):
        path = self._write_toml(_valid_toml(version=2), self._tmp)
        args = self._args(path)
        with patch('models.ScoreDatabase') as mock_db_cls:
            cmd_register(args)
        mock_db_cls.assert_not_called()

    def test_invalid_toml_exits_with_1(self):
        # Write a TOML with a validation error
        bad = {'model': {'version': -1}, 'factor': [_valid_factor()]}
        path = self._write_toml(bad, self._tmp)
        args = self._args(path)
        with self.assertRaises(SystemExit) as ctx:
            with patch('builtins.print'):
                cmd_register(args)
        self.assertEqual(ctx.exception.code, 1)

    def test_invalid_toml_prints_errors(self):
        bad = {'model': {'version': -1}, 'factor': [_valid_factor()]}
        path = self._write_toml(bad, self._tmp)
        args = self._args(path)
        with patch('builtins.print') as mock_print:
            try:
                cmd_register(args)
            except SystemExit:
                pass
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('ERROR', output)

    def test_warning_printed_before_success(self):
        # weights don't sum to 1 → warning but not error
        data = {'model': _valid_model(version=2), 'factor': [_valid_factor(weight=0.5)]}
        path = self._write_toml(data, self._tmp)
        args = self._args(path)
        printed = []
        with patch('builtins.print', side_effect=lambda *a, **kw: printed.append(str(a))):
            cmd_register(args)
        self.assertTrue(any('WARNING' in p for p in printed))
        self.assertTrue(any('Validation passed' in p for p in printed))


# ---------------------------------------------------------------------------
# cmd_register — real DB write (non-dry-run)
# ---------------------------------------------------------------------------

class TestCmdRegisterWrite(unittest.TestCase):

    def setUp(self):
        self._tmp = tempfile.mkdtemp()
        self._db_path = os.path.join(self._tmp, 'test.db')
        self._toml_path = os.path.join(self._tmp, 'model.toml')

    def tearDown(self):
        import shutil
        shutil.rmtree(self._tmp, ignore_errors=True)

    def _write_toml(self, version=2, factors=None):
        lines = [
            '[model]',
            f'version = {version}',
            'description = "Test model"',
        ]
        for f in (factors or [_valid_factor()]):
            lines += [
                '',
                '[[factor]]',
                f'name = "{f["name"]}"',
                f'weight = {f["weight"]}',
                f'formula_type = "{f["formula_type"]}"',
                'inputs = ["prog", "total_exp"]',
                f'direction = "{f["direction"]}"',
                f'benchmark_lo = {f["benchmark_lo"]}',
                f'benchmark_hi = {f["benchmark_hi"]}',
            ]
        with open(self._toml_path, 'w') as fh:
            fh.write('\n'.join(lines))

    def _args(self, dry_run=False, skip_existing=False):
        args = MagicMock()
        args.file = self._toml_path
        args.dry_run = dry_run
        args.skip_existing = skip_existing
        args.db = self._db_path
        return args

    def test_register_creates_model_in_db(self):
        self._write_toml(version=2)
        with patch('builtins.print'):
            cmd_register(self._args())
        from database.Score import ScoreDatabase
        db = ScoreDatabase(path=self._db_path)
        count = db.cursor.execute(
            "SELECT COUNT(*) FROM score_model WHERE version = 2"
        ).fetchone()[0]
        db.close()
        self.assertEqual(count, 1)

    def test_register_creates_factors_in_db(self):
        self._write_toml(version=2)
        with patch('builtins.print'):
            cmd_register(self._args())
        from database.Score import ScoreDatabase
        db = ScoreDatabase(path=self._db_path)
        count = db.cursor.execute(
            "SELECT COUNT(*) FROM score_factor WHERE model_id = "
            "(SELECT model_id FROM score_model WHERE version = 2)"
        ).fetchone()[0]
        db.close()
        self.assertEqual(count, 1)

    def test_register_prints_confirmation(self):
        self._write_toml(version=2)
        with patch('builtins.print') as mock_print:
            cmd_register(self._args())
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('Registered', output)

    def test_duplicate_version_exits_with_1(self):
        self._write_toml(version=2)
        with patch('builtins.print'):
            cmd_register(self._args())
        with self.assertRaises(SystemExit) as ctx:
            with patch('builtins.print'), patch('sys.stderr'):
                cmd_register(self._args())
        self.assertEqual(ctx.exception.code, 1)


# ---------------------------------------------------------------------------
# cmd_register — --skip-existing
# ---------------------------------------------------------------------------

class TestCmdRegisterSkipExisting(unittest.TestCase):

    def setUp(self):
        self._tmp = tempfile.mkdtemp()
        self._db_path = os.path.join(self._tmp, 'test.db')
        self._toml_path = os.path.join(self._tmp, 'model.toml')
        lines = [
            '[model]', 'version = 3', 'description = "Skip test"', '',
            '[[factor]]', 'name = "Test Factor"', 'weight = 1.0',
            'formula_type = "ratio"', 'inputs = ["prog", "total_exp"]',
            'direction = "higher"', 'benchmark_lo = 0.0', 'benchmark_hi = 1.0',
        ]
        with open(self._toml_path, 'w') as fh:
            fh.write('\n'.join(lines))

    def tearDown(self):
        import shutil
        shutil.rmtree(self._tmp, ignore_errors=True)

    def _args(self, skip_existing=False):
        args = MagicMock()
        args.file = self._toml_path
        args.dry_run = False
        args.skip_existing = skip_existing
        args.db = self._db_path
        return args

    def test_skip_existing_on_new_version_registers_normally(self):
        with patch('builtins.print') as mock_print:
            cmd_register(self._args(skip_existing=True))
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('Registered', output)

    def test_skip_existing_on_duplicate_prints_message_and_exits_0(self):
        with patch('builtins.print'):
            cmd_register(self._args())
        with patch('builtins.print') as mock_print:
            cmd_register(self._args(skip_existing=True))
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('already registered', output)

    def test_skip_existing_on_duplicate_does_not_raise(self):
        with patch('builtins.print'):
            cmd_register(self._args())
        try:
            with patch('builtins.print'):
                cmd_register(self._args(skip_existing=True))
        except SystemExit:
            self.fail("skip_existing should not raise SystemExit on duplicate")

    def test_without_skip_existing_duplicate_raises(self):
        with patch('builtins.print'):
            cmd_register(self._args())
        with self.assertRaises(SystemExit):
            with patch('builtins.print'), patch('sys.stderr'):
                cmd_register(self._args(skip_existing=False))


# ---------------------------------------------------------------------------
# cmd_list
# ---------------------------------------------------------------------------

class TestCmdList(unittest.TestCase):

    def setUp(self):
        self._tmp = tempfile.mkdtemp()
        self._db_path = os.path.join(self._tmp, 'test.db')

    def tearDown(self):
        import shutil
        shutil.rmtree(self._tmp, ignore_errors=True)

    def _args(self):
        args = MagicMock()
        args.db = self._db_path
        return args

    def test_list_with_no_models_prints_message(self):
        mock_db = MagicMock()
        mock_db.list_models.return_value = []
        with patch('models.ScoreDatabase', return_value=mock_db), \
             patch('builtins.print') as mock_print:
            cmd_list(self._args())
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('No models', output)

    def test_list_shows_version_1_by_default(self):
        with patch('builtins.print') as mock_print:
            cmd_list(self._args())
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('v1', output)

    def test_list_shows_model_description_when_present(self):
        from database.Score import ScoreDatabase
        db = ScoreDatabase(path=self._db_path)
        db.cursor.execute(
            "UPDATE score_model SET description = 'My desc' WHERE version = 1"
        )
        db.connection.commit()
        db.close()
        with patch('builtins.print') as mock_print:
            cmd_list(self._args())
        output = ' '.join(str(c) for c in mock_print.call_args_list)
        self.assertIn('My desc', output)


# ---------------------------------------------------------------------------
# main() entry point
# ---------------------------------------------------------------------------

class TestMain(unittest.TestCase):

    def test_main_list_calls_cmd_list(self):
        from models import main
        with patch('sys.argv', ['openreturn-models', 'list']), \
             patch('models.cmd_list') as mock_list:
            main()
        mock_list.assert_called_once()

    def test_main_register_calls_cmd_register(self):
        from models import main
        with patch('sys.argv', ['openreturn-models', 'register', 'somefile.toml']), \
             patch('models.cmd_register') as mock_reg:
            main()
        mock_reg.assert_called_once()

    def test_main_register_dry_run_flag_parsed(self):
        from models import main
        captured = {}

        def capture(args):
            captured['dry_run'] = args.dry_run

        with patch('sys.argv', ['openreturn-models', 'register', '--dry-run', 'somefile.toml']), \
             patch('models.cmd_register', side_effect=capture):
            main()
        self.assertTrue(captured.get('dry_run'))

    def test_main_db_flag_parsed(self):
        from models import main
        captured = {}

        def capture(args):
            captured['db'] = args.db

        with patch('sys.argv', ['openreturn-models', '--db', '/tmp/x.db', 'list']), \
             patch('models.cmd_list', side_effect=capture):
            main()
        self.assertEqual(captured.get('db'), '/tmp/x.db')


if __name__ == '__main__':
    unittest.main()
