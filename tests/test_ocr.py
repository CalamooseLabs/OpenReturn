"""Tests for OCR of 990 PDFs. The tesseract/pdftoppm binaries aren't assumed
present, so the engine is exercised via its pure functions (TSV parsing, concept
extraction) and the recording flow is tested by mocking ocr_pdf."""

import os
import sys
import unittest
from unittest.mock import patch

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

import ocr
from database import OpenReturnDB

# A tiny tesseract-style TSV: header + word rows (level..conf,text = 12 cols).
_TSV = "\n".join([
    "level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight\tconf\ttext",
    "5\t1\t1\t1\t1\t1\t10\t10\t40\t12\t96\tTotal",
    "5\t1\t1\t1\t1\t2\t60\t10\t30\t12\t95\tRevenue",
    "5\t1\t1\t1\t1\t3\t200\t10\t50\t12\t90\t1,213,263",
    "5\t1\t1\t1\t2\t1\t10\t30\t40\t12\t88\tTotal",
    "5\t1\t1\t1\t2\t2\t60\t30\t40\t12\t70\tExpenses",
    "5\t1\t1\t1\t2\t3\t200\t30\t50\t12\t72\t1,360,607",
    "5\t1\t1\t1\t3\t1\t10\t50\t30\t12\t-1\t ",   # conf -1 / blank → skipped
])


class TestOcrPureFunctions(unittest.TestCase):
    def test_parse_tsv(self):
        words = ocr.parse_tsv(_TSV)
        self.assertEqual(len(words), 6)                 # blank/-1 row dropped
        self.assertAlmostEqual(words[0]['conf'], 0.96)
        self.assertEqual(words[0]['text'], 'Total')

    def test_extract_concepts(self):
        concepts = ocr.extract_concepts(ocr.parse_tsv(_TSV))
        self.assertIn('cy_rev', concepts)
        self.assertEqual(concepts['cy_rev']['value'], 1213263.0)
        # confidence = min over label + amount tokens (Total .96 / Revenue .95 / amount .90)
        self.assertAlmostEqual(concepts['cy_rev']['confidence'], 0.90)
        self.assertEqual(concepts['cy_exp']['value'], 1360607.0)
        self.assertAlmostEqual(concepts['cy_exp']['confidence'], 0.70)

    def test_amount_parsing_handles_parens_and_commas(self):
        self.assertEqual(ocr._amount_to_float("(1,234)"), -1234.0)
        self.assertEqual(ocr._amount_to_float("$5,000.50"), 5000.50)
        self.assertIsNone(ocr._amount_to_float("n/a"))


class TestOcrRecording(unittest.TestCase):
    def setUp(self):
        self.db = OpenReturnDB(path=':memory:')
        self.db.cursor.execute("INSERT INTO organization (ein, name) VALUES ('364348917','AJ')")
        self.db.connection.commit()

    def tearDown(self):
        self.db.close()

    def test_record_ocr_creates_observations_with_confidence(self):
        result = {"pages": 1, "concepts": {
            "cy_rev": {"value": 1213263.0, "confidence": 0.90},
            "cy_exp": {"value": 1360607.0, "confidence": 0.70}}}
        out = ocr.record_ocr(self.db, '364348917', 2024, result, filename='aj.pdf')
        self.assertEqual(out['recorded'], 2)
        facts = {f['concept_code']: f for f in
                 self.db.financials.get_org_financials('364348917', 2024)['facts']}
        obs = facts['cy_rev']['observations'][0]
        self.assertEqual(obs['source_code'], 'ocr_990_pdf')
        self.assertAlmostEqual(obs['confidence'], 0.90)
        self.assertEqual(obs['value'], 1213263.0)

    def test_ocr_pdf_requires_engine(self):
        with patch('ocr.ocr_available', return_value=False):
            with self.assertRaises(RuntimeError):
                ocr.ocr_pdf('whatever.pdf')

    def test_record_ocr_empty_is_noop(self):
        out = ocr.record_ocr(self.db, '364348917', 2024, {"pages": 0, "concepts": {}})
        self.assertEqual(out['recorded'], 0)


@unittest.skipUnless(ocr.ocr_available(), "tesseract/pdftoppm not installed")
class TestOcrLive(unittest.TestCase):
    def test_available(self):
        self.assertTrue(ocr.ocr_available())


if __name__ == '__main__':
    unittest.main()
