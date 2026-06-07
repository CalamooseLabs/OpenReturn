import io
import os
import sys
import tempfile
import unittest
import zipfile
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from unzipper import Unzipper


def _write_zip(path: str, files: dict[str, str]):
    with zipfile.ZipFile(path, 'w') as zf:
        for name, content in files.items():
            zf.writestr(name, content)


class UnzipperTestCase(unittest.TestCase):
    def setUp(self):
        self._tmpdir = tempfile.mkdtemp()

    def tearDown(self):
        import shutil
        shutil.rmtree(self._tmpdir, ignore_errors=True)

    def _zip(self, name='test.zip', **files):
        path = os.path.join(self._tmpdir, name)
        _write_zip(path, files)
        return path


# ---------------------------------------------------------------------------
# Normal (well-formed) ZIP — uses Python zipfile path
# ---------------------------------------------------------------------------

class TestUnzipperNormalZip(UnzipperTestCase):

    def test_iterates_all_files(self):
        uz = Unzipper(self._zip(**{'a.xml': 'a', 'b.xml': 'b', 'c.xml': 'c'}))
        self.assertEqual(len(list(uz)), 3)
        uz.close()

    def test_file_names_are_strings(self):
        uz = Unzipper(self._zip(**{'a.xml': 'a'}))
        for u in uz:
            self.assertIsInstance(u.name(), str)
        uz.close()

    def test_read_returns_string(self):
        uz = Unzipper(self._zip(**{'a.xml': 'hello'}))
        for u in uz:
            self.assertIsInstance(u.read(), str)
        uz.close()

    def test_read_correct_content(self):
        uz = Unzipper(self._zip(**{'a.xml': '<root>alpha</root>', 'b.xml': '<root>beta</root>'}))
        contents = {u.name(): u.read() for u in uz}
        uz.close()
        self.assertEqual(contents['a.xml'], '<root>alpha</root>')
        self.assertEqual(contents['b.xml'], '<root>beta</root>')

    def test_name_and_read_consistent(self):
        uz = Unzipper(self._zip(**{'thing.xml': 'value'}))
        for u in uz:
            if u.name() == 'thing.xml':
                self.assertEqual(u.read(), 'value')
        uz.close()

    def test_directories_not_yielded(self):
        buf = io.BytesIO()
        with zipfile.ZipFile(buf, 'w') as zf:
            zf.mkdir('emptydir/')
            zf.writestr('file.xml', 'content')
        path = os.path.join(self._tmpdir, 'dirs.zip')
        with open(path, 'wb') as f:
            f.write(buf.getvalue())
        uz = Unzipper(path)
        names = [u.name() for u in uz]
        uz.close()
        self.assertNotIn('emptydir/', names)
        self.assertIn('file.xml', names)

    def test_stop_iteration_after_last_file(self):
        uz = Unzipper(self._zip(**{'x.xml': 'x'}))
        list(uz)
        with self.assertRaises(StopIteration):
            next(uz)
        uz.close()

    def test_single_file_zip(self):
        uz = Unzipper(self._zip(**{'only.xml': 'hello'}))
        names = [u.name() for u in uz]
        uz.close()
        self.assertEqual(names, ['only.xml'])

    def test_empty_zip_iterates_zero_times(self):
        uz = Unzipper(self._zip())
        self.assertEqual(list(uz), [])
        uz.close()

    def test_totally_invalid_file_raises(self):
        path = os.path.join(self._tmpdir, 'bad.zip')
        with open(path, 'wb') as f:
            f.write(b'this is not a zip')
        with self.assertRaises(Exception):
            Unzipper(path)

    def test_close_safe_to_call_twice(self):
        uz = Unzipper(self._zip(**{'x.xml': 'x'}))
        uz.close()
        uz.close()

    def test_normal_zip_uses_zipfile_not_subprocess(self):
        uz = Unzipper(self._zip(**{'x.xml': 'x'}))
        self.assertIsNotNone(uz._zip)
        self.assertIsNone(uz._tmpdir)
        uz.close()


# ---------------------------------------------------------------------------
# Fallback path — tested via mocks that simulate BadZipFile conditions
# ---------------------------------------------------------------------------

class TestUnzipperFallback(UnzipperTestCase):
    """
    Force the subprocess fallback by mocking is_zipfile or ZipFile to raise
    BadZipFile — the same condition triggered by IRS ZIPs with bad headers.
    """

    def test_is_zipfile_false_uses_fallback(self):
        path = self._zip(**{'x.xml': 'content'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        self.assertIsNone(uz._zip)
        self.assertIsNotNone(uz._tmpdir)
        uz.close()

    def test_zipfile_constructor_raises_uses_fallback(self):
        path = self._zip(**{'x.xml': 'content'})
        with patch('unzipper.unzipper.zf.ZipFile', side_effect=zipfile.BadZipFile):
            uz = Unzipper(path)
        self.assertIsNone(uz._zip)
        self.assertIsNotNone(uz._tmpdir)
        uz.close()

    def test_bad_header_probe_uses_fallback(self):
        """ZipFile() succeeds but open() on the first entry raises BadZipFile."""
        path = self._zip(**{'x.xml': 'content'})
        mock_zip = MagicMock()
        mock_zip.namelist.return_value = ['x.xml']
        mock_zip.open.side_effect = zipfile.BadZipFile
        with patch('unzipper.unzipper.zf.ZipFile', return_value=mock_zip):
            uz = Unzipper(path)
        self.assertIsNone(uz._zip)
        self.assertIsNotNone(uz._tmpdir)
        uz.close()

    def test_fallback_iterates_files(self):
        path = self._zip(**{'a.xml': '<a/>', 'b.xml': '<b/>'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        names = [u.name() for u in uz]
        uz.close()
        self.assertEqual(len(names), 2)

    def test_fallback_read_returns_correct_content(self):
        path = self._zip(**{'data.xml': '<data>hello</data>'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        contents = {u.name(): u.read() for u in uz}
        uz.close()
        self.assertIn('data.xml', contents)
        self.assertEqual(contents['data.xml'], '<data>hello</data>')

    def test_fallback_read_returns_string(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        for u in uz:
            self.assertIsInstance(u.read(), str)
        uz.close()

    def test_fallback_names_are_strings(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        for u in uz:
            self.assertIsInstance(u.name(), str)
        uz.close()

    def test_fallback_multiple_files_all_readable(self):
        files = {f'filing_{i}.xml': f'<filing>{i}</filing>' for i in range(5)}
        path = self._zip(**files)
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        results = {u.name(): u.read() for u in uz}
        uz.close()
        for i in range(5):
            self.assertEqual(results[f'filing_{i}.xml'], f'<filing>{i}</filing>')

    def test_fallback_close_removes_tempdir(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        tmpdir = uz._tmpdir
        self.assertTrue(os.path.isdir(tmpdir))
        uz.close()
        self.assertFalse(os.path.isdir(tmpdir))

    def test_fallback_close_sets_tmpdir_to_none(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        uz.close()
        self.assertIsNone(uz._tmpdir)

    def test_fallback_close_safe_to_call_twice(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        uz.close()
        uz.close()

    def test_fallback_stop_iteration_after_last_file(self):
        path = self._zip(**{'x.xml': 'x'})
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False):
            uz = Unzipper(path)
        list(uz)
        with self.assertRaises(StopIteration):
            next(uz)
        uz.close()

    def test_unzip_exit_1_warnings_accepted(self):
        """unzip exit code 1 means minor warnings — should still work."""
        path = self._zip(**{'x.xml': 'content'})
        mock_result = MagicMock()
        mock_result.returncode = 1
        real_run = __import__('subprocess').run

        def fake_run(cmd, **kwargs):
            real_run(cmd, **kwargs)
            return mock_result

        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False), \
             patch('unzipper.unzipper.subprocess.run', side_effect=fake_run):
            uz = Unzipper(path)
        results = {u.name(): u.read() for u in uz}
        uz.close()
        self.assertEqual(results['x.xml'], 'content')

    def test_unzip_exit_2_raises_value_error(self):
        path = self._zip(**{'x.xml': 'x'})
        mock_result = MagicMock()
        mock_result.returncode = 2
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False), \
             patch('unzipper.unzipper.subprocess.run', return_value=mock_result):
            with self.assertRaises(ValueError):
                Unzipper(path)

    def test_unzip_failure_error_message_contains_path(self):
        path = self._zip(**{'x.xml': 'x'})
        mock_result = MagicMock()
        mock_result.returncode = 3
        with patch('unzipper.unzipper.zf.is_zipfile', return_value=False), \
             patch('unzipper.unzipper.subprocess.run', return_value=mock_result):
            with self.assertRaises(ValueError) as ctx:
                Unzipper(path)
        self.assertIn(path, str(ctx.exception))


class TestUnzipperSymlinkProtection(unittest.TestCase):
    """Symlinks in the extracted tmpdir must be skipped to prevent symlink attacks."""

    def _zip(self, **files) -> str:
        import tempfile, zipfile
        tmp = tempfile.mktemp(suffix='.zip')
        with zipfile.ZipFile(tmp, 'w') as zf:
            for name, content in files.items():
                zf.writestr(name, content)
        return tmp

    def test_symlinks_excluded_from_file_list(self):
        path = self._zip(**{'real.xml': '<data/>'})
        try:
            with patch('unzipper.unzipper.zf.is_zipfile', return_value=False), \
                 patch('unzipper.unzipper.os.path.islink', return_value=True):
                uz = Unzipper(path)
            self.assertEqual(len(uz.files), 0)
            uz.close()
        finally:
            os.unlink(path)

    def test_non_symlinks_still_included(self):
        path = self._zip(**{'real.xml': '<data/>'})
        try:
            with patch('unzipper.unzipper.zf.is_zipfile', return_value=False), \
                 patch('unzipper.unzipper.os.path.islink', return_value=False):
                uz = Unzipper(path)
            self.assertEqual(len(uz.files), 1)
            uz.close()
        finally:
            os.unlink(path)


if __name__ == '__main__':
    unittest.main()
