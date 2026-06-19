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

    def test_row_total_picks_the_total_column_not_the_rightmost(self):
        # Part IX line 25 "Total functional expenses" row: a line number then the
        # four columns [Total, Program, Mgmt, Fundraising]. The right-most amount
        # is fundraising and the left-most is the line number — the total is the
        # LARGEST amount, which is what we must extract for total_exp.
        tsv = "\n".join([
            "level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight\tconf\ttext",
            "5\t1\t1\t1\t1\t1\t10\t10\t20\t12\t95\t25",
            "5\t1\t1\t1\t1\t2\t40\t10\t40\t12\t95\tTotal",
            "5\t1\t1\t1\t1\t3\t90\t10\t60\t12\t95\tfunctional",
            "5\t1\t1\t1\t1\t4\t160\t10\t60\t12\t95\texpenses",
            "5\t1\t1\t1\t1\t5\t300\t10\t50\t12\t90\t1,360,607",
            "5\t1\t1\t1\t1\t6\t380\t10\t50\t12\t90\t1,083,299",
            "5\t1\t1\t1\t1\t7\t460\t10\t50\t12\t90\t142,178",
            "5\t1\t1\t1\t1\t8\t540\t10\t50\t12\t90\t135,130",
        ])
        concepts = ocr.extract_concepts(ocr.parse_tsv(tsv))
        self.assertEqual(concepts["total_exp"]["value"], 1360607.0)

    def test_detect_form_distinguishes_990_ez_pf(self):
        head = ("level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight"
                "\tconf\ttext")

        def words_for(title):
            rows = [head]
            for i, tok in enumerate(title.split(), start=1):
                rows.append(f"5\t1\t1\t1\t1\t{i}\t{i * 40}\t10\t30\t12\t95\t{tok}")
            return ocr.parse_tsv("\n".join(rows), page=0)

        # A standard 990's subtitle says "(except private foundations)" — that must
        # NOT be mistaken for a PF (we key on the PF title "Return of Private
        # Foundation", not the bare phrase).
        self.assertEqual(ocr.detect_form(words_for(
            "Return of Organization Exempt From Income Tax "
            "except private foundations")), "990")
        self.assertEqual(
            ocr.detect_form(words_for("Return of Private Foundation")), "990PF")
        self.assertEqual(ocr.detect_form(words_for(
            "Short Form Return of Organization Exempt From Income Tax")), "990EZ")

    def test_pf_form_routes_shared_label_to_pf_concept(self):
        # "Total assets" means pf_total_assets on a 990-PF, but the 990 `assets`
        # concept on a 990 — the form-scoped map is what disambiguates them.
        tsv = "\n".join([
            "level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight\tconf\ttext",
            "5\t1\t1\t1\t1\t1\t10\t10\t40\t12\t95\tTotal",
            "5\t1\t1\t1\t1\t2\t60\t10\t40\t12\t95\tassets",
            "5\t1\t1\t1\t1\t3\t200\t10\t60\t12\t90\t9,000,000",
        ])
        pf = ocr.extract_concepts(ocr.parse_tsv(tsv), form="990PF")
        self.assertEqual(pf["pf_total_assets"]["value"], 9000000.0)
        self.assertNotIn("assets", pf)
        nonprofit = ocr.extract_concepts(ocr.parse_tsv(tsv), form="990")
        self.assertEqual(nonprofit["assets"]["value"], 9000000.0)
        self.assertNotIn("pf_total_assets", nonprofit)

    def test_low_confidence_reading_is_flagged_for_review(self):
        tsv = "\n".join([
            "level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight\tconf\ttext",
            "5\t1\t1\t1\t1\t1\t10\t10\t40\t12\t60\tTotal",
            "5\t1\t1\t1\t1\t2\t60\t10\t40\t12\t55\tRevenue",
            "5\t1\t1\t1\t1\t3\t200\t10\t40\t12\t58\t100",
        ])
        low = ocr.extract_concepts(ocr.parse_tsv(tsv))
        self.assertTrue(low["cy_rev"]["review"])         # 0.55 < threshold
        # The high-confidence fixture (cy_rev conf 0.90) is not flagged.
        self.assertFalse(ocr.extract_concepts(ocr.parse_tsv(_TSV))["cy_rev"]["review"])

    def test_pages_are_kept_distinct_so_lines_do_not_merge(self):
        # tesseract resets its TSV page column to 1 for every page image, so two
        # different physical pages can share line coordinates. parse_tsv(page=…)
        # tags each so extract_concepts won't merge them: a "Total Revenue" line on
        # page 0 and a "Total Expenses" line at the SAME coords on page 1 must keep
        # their own amounts (else cy_rev would steal the right-most merged amount).
        head = ("level\tpage\tblock\tpar\tline\tword\tleft\ttop\twidth\theight"
                "\tconf\ttext")
        page0 = "\n".join([
            head,
            "5\t1\t1\t1\t1\t1\t10\t10\t40\t12\t96\tTotal",
            "5\t1\t1\t1\t1\t2\t60\t10\t40\t12\t95\tRevenue",
            "5\t1\t1\t1\t1\t3\t200\t10\t40\t12\t90\t100",
        ])
        page1 = "\n".join([
            head,
            "5\t1\t1\t1\t1\t1\t10\t10\t40\t12\t96\tTotal",
            "5\t1\t1\t1\t1\t2\t60\t10\t40\t12\t95\tExpenses",
            "5\t1\t1\t1\t1\t3\t200\t10\t40\t12\t90\t200",
        ])
        words = ocr.parse_tsv(page0, page=0) + ocr.parse_tsv(page1, page=1)
        concepts = ocr.extract_concepts(words)
        self.assertEqual(concepts["cy_rev"]["value"], 100.0)
        self.assertEqual(concepts["cy_exp"]["value"], 200.0)


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
