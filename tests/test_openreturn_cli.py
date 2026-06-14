"""Tests for src/cli.py — _load_env and unified CLI dispatch."""

import contextlib
import io
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest.mock import MagicMock, patch

_SRC = os.path.join(os.path.dirname(__file__), '..', 'src')
sys.path.insert(0, _SRC)

import cli as cli_mod


# ---------------------------------------------------------------------------
# _load_env
# ---------------------------------------------------------------------------

class TestLoadEnv(unittest.TestCase):

    def _run(self, content: str | None = None, path: str = '.env'):
        """Write content to a temp .env, call _load_env, return env snapshot."""
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            if content is not None:
                Path(env_path).write_text(content)
            with patch.dict(os.environ, {}, clear=False):
                cli_mod._load_env(env_path if content is not None else os.path.join(td, 'missing.env'))
                return dict(os.environ)

    def test_missing_file_does_not_raise(self):
        with tempfile.TemporaryDirectory() as td:
            cli_mod._load_env(os.path.join(td, 'no_such_file.env'))

    def test_basic_key_value(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("FOO=bar\n")
            with patch.dict(os.environ, {}, clear=False):
                os.environ.pop('FOO', None)
                cli_mod._load_env(env_path)
                self.assertEqual(os.environ.get('FOO'), 'bar')
                del os.environ['FOO']

    def test_comment_lines_skipped(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("# this is a comment\nFOO2=baz\n")
            with patch.dict(os.environ, {}, clear=False):
                os.environ.pop('FOO2', None)
                cli_mod._load_env(env_path)
                self.assertEqual(os.environ.get('FOO2'), 'baz')
                del os.environ['FOO2']

    def test_blank_lines_skipped(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("\n\nFOO3=qux\n\n")
            with patch.dict(os.environ, {}, clear=False):
                os.environ.pop('FOO3', None)
                cli_mod._load_env(env_path)
                self.assertEqual(os.environ.get('FOO3'), 'qux')
                del os.environ['FOO3']

    def test_lines_without_equals_skipped(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("NOEQUALSSIGN\nFOO4=val\n")
            with patch.dict(os.environ, {}, clear=False):
                os.environ.pop('FOO4', None)
                cli_mod._load_env(env_path)
                self.assertNotIn('NOEQUALSSIGN', os.environ)
                self.assertEqual(os.environ.get('FOO4'), 'val')
                del os.environ['FOO4']

    def test_existing_env_var_not_overridden(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("FOO5=from_file\n")
            with patch.dict(os.environ, {'FOO5': 'already_set'}, clear=False):
                cli_mod._load_env(env_path)
                self.assertEqual(os.environ.get('FOO5'), 'already_set')

    def test_value_with_equals_in_it(self):
        with tempfile.TemporaryDirectory() as td:
            env_path = os.path.join(td, '.env')
            Path(env_path).write_text("URL=http://example.com?a=1&b=2\n")
            with patch.dict(os.environ, {}, clear=False):
                os.environ.pop('URL', None)
                cli_mod._load_env(env_path)
                self.assertEqual(os.environ.get('URL'), 'http://example.com?a=1&b=2')
                del os.environ['URL']


# ---------------------------------------------------------------------------
# CLI dispatch
# ---------------------------------------------------------------------------

class TestCliDispatch(unittest.TestCase):

    def _run(self, argv, extra_patches=None):
        patches = [patch('sys.argv', ['openreturn'] + argv)]
        if extra_patches:
            patches.extend(extra_patches)
        with contextlib.ExitStack() as stack:
            for p in patches:
                stack.enter_context(p)
            buf = io.StringIO()
            with contextlib.redirect_stdout(buf):
                result = cli_mod.main()
        return result

    # ── serve ─────────────────────────────────────────────────────────────

    def test_serve_dispatches_to_cmd_serve(self):
        mock_serve = MagicMock(return_value=0)
        with patch('main.cmd_serve', mock_serve), patch('cli._load_env'):
            result = self._run(['serve'])
        self.assertEqual(result, 0)
        mock_serve.assert_called_once()

    def test_serve_passes_host_and_port(self):
        captured = {}

        def fake_serve(args):
            captured['host'] = args.host
            captured['port'] = args.port
            return 0

        with patch('main.cmd_serve', fake_serve), patch('cli._load_env'):
            result = self._run(['serve', '--host', '0.0.0.0', '--port', '9090'])
        self.assertEqual(captured['host'], '0.0.0.0')
        self.assertEqual(captured['port'], 9090)

    def test_serve_debug_flag(self):
        captured = {}

        def fake_serve(args):
            captured['debug'] = args.debug
            return 0

        with patch('main.cmd_serve', fake_serve), patch('cli._load_env'):
            self._run(['serve', '--debug'])
        self.assertTrue(captured['debug'])

    def test_serve_auth_flag(self):
        captured = {}

        def fake_serve(args):
            captured['auth'] = args.auth
            return 0

        with patch('main.cmd_serve', fake_serve), patch('cli._load_env'):
            self._run(['serve', '--auth'])
        self.assertTrue(captured['auth'])

    # ── ingest ────────────────────────────────────────────────────────────

    def test_ingest_dispatches_to_cmd_ingest(self):
        mock_ingest = MagicMock(return_value=0)
        with patch('ingest.cmd_ingest', mock_ingest), patch('cli._load_env'):
            result = self._run(['ingest', '/some/dir'])
        self.assertEqual(result, 0)
        mock_ingest.assert_called_once()

    def test_ingest_passes_directory(self):
        captured = {}

        def fake_ingest(args):
            captured['directory'] = args.directory
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '/data/zips'])
        self.assertEqual(captured['directory'], '/data/zips')

    def test_ingest_workers_flag(self):
        captured = {}

        def fake_ingest(args):
            captured['workers'] = args.workers
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '--workers', '4', '/data/zips'])
        self.assertEqual(captured['workers'], 4)

    def test_ingest_optional_directory(self):
        captured = {}

        def fake_ingest(args):
            captured['directory'] = args.directory
            captured['ingested'] = args.ingested
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '--ingested'])
        self.assertIsNone(captured['directory'])
        self.assertTrue(captured['ingested'])

    def test_ingest_background_and_log_flags(self):
        captured = {}

        def fake_ingest(args):
            captured['background'] = args.background
            captured['log'] = args.log
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '/data/zips', '--background', '--log', '/tmp/i.log'])
        self.assertTrue(captured['background'])
        self.assertEqual(captured['log'], '/tmp/i.log')

    def test_ingest_stop_flag(self):
        captured = {}

        def fake_ingest(args):
            captured['stop'] = args.stop
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '--stop'])
        self.assertTrue(captured['stop'])

    def test_ingest_schedule_and_restart_server_flags(self):
        captured = {}

        def fake_ingest(args):
            captured['schedule'] = args.schedule
            captured['restart_server'] = args.restart_server
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '/data/zips', '--schedule', '02:00', '--restart-server'])
        self.assertEqual(captured['schedule'], '02:00')
        self.assertTrue(captured['restart_server'])

    def test_ingest_forget_and_purge_flags(self):
        captured = {}

        def fake_ingest(args):
            captured['forget'] = args.forget
            captured['forget_all'] = args.forget_all
            captured['purge'] = args.purge
            captured['purge_all'] = args.purge_all
            captured['yes'] = args.yes
            return 0

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '--forget', '2023'])
        self.assertEqual(captured['forget'], '2023')

        with patch('ingest.cmd_ingest', fake_ingest), patch('cli._load_env'):
            self._run(['ingest', '--purge-all', '--yes'])
        self.assertTrue(captured['purge_all'])
        self.assertTrue(captured['yes'])

    # ── status ──────────────────────────────────────────────────────────────

    def test_status_dispatches(self):
        captured = {}

        def fake_status(args):
            captured['host'] = args.host
            captured['port'] = args.port
            captured['as_json'] = args.as_json
            return 0

        with patch('status.cmd_status', fake_status), patch('cli._load_env'):
            result = self._run(['status', '--host', '0.0.0.0', '--port', '9000', '--json'])
        self.assertEqual(result, 0)
        self.assertEqual(captured['host'], '0.0.0.0')
        self.assertEqual(captured['port'], 9000)
        self.assertTrue(captured['as_json'])

    # ── reset ───────────────────────────────────────────────────────────────

    def test_reset_dispatches(self):
        captured = {}

        def fake_reset(args):
            captured['yes'] = args.yes
            captured['db'] = args.db
            return 0

        with patch('db.cmd_reset', fake_reset), patch('cli._load_env'):
            result = self._run(['reset', '--yes', '--db', '/tmp/x.db'])
        self.assertEqual(result, 0)
        self.assertTrue(captured['yes'])
        self.assertEqual(captured['db'], '/tmp/x.db')

    # ── keys ──────────────────────────────────────────────────────────────

    def test_keys_list_dispatches(self):
        mock_db = MagicMock()
        mock_db.keys.list_api_keys.return_value = []
        with patch('keys._require_db', return_value=mock_db), patch('cli._load_env'):
            result = self._run(['keys', 'list'])
        self.assertEqual(result, 0)

    def test_keys_create_dispatches(self):
        mock_db = MagicMock()
        mock_db.keys.create_api_key.return_value = (1, 'tok')
        with patch('keys._require_db', return_value=mock_db), patch('cli._load_env'):
            result = self._run(['keys', 'create', 'MyApp'])
        self.assertEqual(result, 0)

    def test_keys_revoke_dispatches(self):
        mock_db = MagicMock()
        mock_db.keys.revoke_api_key.return_value = True
        with patch('keys._require_db', return_value=mock_db), patch('cli._load_env'):
            result = self._run(['keys', 'revoke', '7'])
        self.assertEqual(result, 0)

    def test_keys_missing_subcommand_raises(self):
        with patch('cli._load_env'):
            with self.assertRaises(SystemExit):
                self._run(['keys'])

    # ── models ────────────────────────────────────────────────────────────

    def test_models_list_dispatches(self):
        mock_db = MagicMock()
        mock_db.cursor.execute.return_value.fetchall.return_value = []
        with patch('models.OpenReturnDB', return_value=mock_db), patch('cli._load_env'):
            result = self._run(['models', 'list'])
        self.assertEqual(result, 0)

    def test_models_register_dispatches(self):
        with tempfile.TemporaryDirectory() as td:
            toml_path = os.path.join(td, 'model.toml')
            Path(toml_path).write_text(
                "[model]\nversion = 1\n\n[[factor]]\n"
                "name = \"A\"\nweight = 1.0\nformula_type = \"ratio\"\n"
                "inputs = [\"cy_rev\", \"total_exp\"]\ndirection = \"higher\"\n"
                "benchmark_lo = 0.0\nbenchmark_hi = 1.0\n"
            )
            mock_db = MagicMock()
            mock_db.cursor.execute.return_value.fetchone.return_value = None
            mock_db.cursor.lastrowid = 1
            with patch('models.OpenReturnDB', return_value=mock_db), patch('cli._load_env'):
                result = self._run(['models', 'register', toml_path])
        self.assertEqual(result, 0)

    def test_models_register_skip_existing_flag(self):
        captured = {}

        def fake_register(args):
            captured['skip_existing'] = args.skip_existing

        with patch('models.cmd_register', fake_register), patch('cli._load_env'):
            self._run(['models', 'register', '--skip-existing', 'file.toml'])
        self.assertTrue(captured.get('skip_existing'))

    def test_models_missing_subcommand_raises(self):
        with patch('cli._load_env'):
            with self.assertRaises(SystemExit):
                self._run(['models'])

    def test_missing_top_command_raises(self):
        with patch('cli._load_env'):
            with self.assertRaises(SystemExit):
                self._run([])


if __name__ == '__main__':  # pragma: no cover
    unittest.main()
