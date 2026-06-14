"""Tests for expanded 990 form type support: 990-EZ, 990-N, 990-PF, 990-T."""

import os
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from database import OpenReturnDB
from parser.IRS990 import IRS990Parser
from tests.fixtures import (
    VALID_990EZ_XML,
    VALID_990N_XML,
    VALID_990PF_XML,
    VALID_990T_XML,
)

_EIN_PATH  = "ReturnHeader/Filer/EIN"
_NAME_PATH = "ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"
_YEAR_PATH = "ReturnHeader/TaxYr"
_FORM_PATH = "ReturnHeader/ReturnTypeCd"


def _make_db():
    return OpenReturnDB(path=":memory:")


def _run_xml(xml_str: str, db: OpenReturnDB) -> dict:
    """Parse a single XML string through the full pipeline. Returns result dict."""
    parser = IRS990Parser(xml_str)
    ein       = parser.getElem(_EIN_PATH)
    name      = parser.getElem(_NAME_PATH)
    year      = parser.getElem(_YEAR_PATH)
    form_code = parser.getElem(_FORM_PATH)
    if not all([ein, name, year, form_code]):
        return {"status": "error", "reason": "missing header fields"}
    if form_code not in db.meta.get_supported_forms():
        return {"status": "skipped", "reason": f"unsupported: {form_code}"}
    db.orgs.upsert_organization(ein, name)
    filing_id = db.filings.create_filing(ein, int(year), form_code)
    xpath_index = db.meta.get_xpath_index()
    values = {}
    for xpath, field_id in xpath_index.items():
        value = parser.getElem(xpath)
        if value is not None:
            values[field_id] = value
    db.reported_data.store_reported_data(filing_id, values)
    db.commit()
    return {"status": "stored", "filing_id": filing_id, "ein": ein,
            "year": year, "form_code": form_code, "fields_stored": len(values)}


# ---------------------------------------------------------------------------
# Database schema: verify new form types are registered and supported
# ---------------------------------------------------------------------------

class TestNewFormsRegistered(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = _make_db()

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def test_990ez_is_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertIn("990EZ", forms)

    def test_990n_is_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertIn("990N", forms)

    def test_990pf_is_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertIn("990PF", forms)

    def test_990t_is_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertIn("990T", forms)

    def test_990_still_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertIn("990", forms)

    def test_all_five_forms_supported(self):
        forms = self.db.meta.get_supported_forms()
        self.assertEqual(forms, {"990", "990EZ", "990N", "990PF", "990T"})

    def test_990ez_has_parts_defined(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM part WHERE form_code = '990EZ'"
        ).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990n_has_parts_defined(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM part WHERE form_code = '990N'"
        ).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990pf_has_parts_defined(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM part WHERE form_code = '990PF'"
        ).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990t_has_parts_defined(self):
        count = self.db.cursor.execute(
            "SELECT COUNT(*) FROM part WHERE form_code = '990T'"
        ).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990ez_has_fields_with_xml_paths(self):
        count = self.db.cursor.execute("""
            SELECT COUNT(*) FROM field fi
            JOIN line l ON l.line_id = fi.line_id
            JOIN section s ON s.section_id = l.section_id
            JOIN part p ON p.part_id = s.part_id
            WHERE p.form_code = '990EZ' AND fi.xml_path IS NOT NULL
        """).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990pf_has_fields_with_xml_paths(self):
        count = self.db.cursor.execute("""
            SELECT COUNT(*) FROM field fi
            JOIN line l ON l.line_id = fi.line_id
            JOIN section s ON s.section_id = l.section_id
            JOIN part p ON p.part_id = s.part_id
            WHERE p.form_code = '990PF' AND fi.xml_path IS NOT NULL
        """).fetchone()[0]
        self.assertGreater(count, 0)

    def test_990t_has_fields_with_xml_paths(self):
        count = self.db.cursor.execute("""
            SELECT COUNT(*) FROM field fi
            JOIN line l ON l.line_id = fi.line_id
            JOIN section s ON s.section_id = l.section_id
            JOIN part p ON p.part_id = s.part_id
            WHERE p.form_code = '990T' AND fi.xml_path IS NOT NULL
        """).fetchone()[0]
        self.assertGreater(count, 0)

    def test_new_form_xpath_paths_are_unique(self):
        """New form XPath paths should be unique — no inadvertent cross-form duplication."""
        rows = self.db.cursor.execute("""
            SELECT fi.xml_path, COUNT(*) FROM field fi
            JOIN line l ON l.line_id = fi.line_id
            JOIN section s ON s.section_id = l.section_id
            JOIN part p ON p.part_id = s.part_id
            WHERE fi.xml_path IS NOT NULL
              AND p.form_code IN ('990EZ', '990N', '990PF', '990T')
            GROUP BY fi.xml_path HAVING COUNT(*) > 1
        """).fetchall()
        self.assertEqual(rows, [], f"Duplicate xml_paths in new forms: {rows}")


# ---------------------------------------------------------------------------
# Parser: verify form codes are read correctly from each fixture
# ---------------------------------------------------------------------------

class TestParserReadsNewForms(unittest.TestCase):

    def test_990ez_form_code(self):
        p = IRS990Parser(VALID_990EZ_XML)
        self.assertEqual(p.getElem(_FORM_PATH), "990EZ")

    def test_990n_form_code(self):
        p = IRS990Parser(VALID_990N_XML)
        self.assertEqual(p.getElem(_FORM_PATH), "990N")

    def test_990pf_form_code(self):
        p = IRS990Parser(VALID_990PF_XML)
        self.assertEqual(p.getElem(_FORM_PATH), "990PF")

    def test_990t_form_code(self):
        p = IRS990Parser(VALID_990T_XML)
        self.assertEqual(p.getElem(_FORM_PATH), "990T")

    def test_990ez_ein(self):
        p = IRS990Parser(VALID_990EZ_XML)
        self.assertEqual(p.getElem(_EIN_PATH), "111111111")

    def test_990n_ein(self):
        p = IRS990Parser(VALID_990N_XML)
        self.assertEqual(p.getElem(_EIN_PATH), "222222222")

    def test_990pf_ein(self):
        p = IRS990Parser(VALID_990PF_XML)
        self.assertEqual(p.getElem(_EIN_PATH), "333333333")

    def test_990t_ein(self):
        p = IRS990Parser(VALID_990T_XML)
        self.assertEqual(p.getElem(_EIN_PATH), "444444444")

    def test_990ez_field_extracted(self):
        p = IRS990Parser(VALID_990EZ_XML)
        value = p.getElem("ReturnData/IRS990EZ/TotalRevenueAmt")
        self.assertEqual(value, "176000")

    def test_990ez_mission_extracted(self):
        p = IRS990Parser(VALID_990EZ_XML)
        value = p.getElem("ReturnData/IRS990EZ/PrimaryExemptPurposeTxt")
        self.assertEqual(value, "Providing community services")

    def test_990n_website_extracted(self):
        p = IRS990Parser(VALID_990N_XML)
        value = p.getElem("ReturnData/IRS990N/WebsiteAddressTxt")
        self.assertEqual(value, "www.tinycommunitygroup.org")

    def test_990pf_total_assets_extracted(self):
        p = IRS990Parser(VALID_990PF_XML)
        value = p.getElem("ReturnData/IRS990PF/TotalAssetsEOYAmt")
        self.assertEqual(value, "5000000")

    def test_990pf_nested_revenue_extracted(self):
        p = IRS990Parser(VALID_990PF_XML)
        value = p.getElem(
            "ReturnData/IRS990PF/AnalysisRevExpnssGrp/TotalRevAndExpnssGrp/RevenueAndExpensesPerBooksAmt"
        )
        self.assertEqual(value, "550000")

    def test_990t_gross_ubi_extracted(self):
        p = IRS990Parser(VALID_990T_XML)
        value = p.getElem("ReturnData/IRS990T/TotalGrossUBIAmt")
        self.assertEqual(value, "300000")

    def test_990t_total_tax_extracted(self):
        p = IRS990Parser(VALID_990T_XML)
        value = p.getElem("ReturnData/IRS990T/TotalTaxAmt")
        self.assertEqual(value, "21000")


# ---------------------------------------------------------------------------
# Full pipeline: store each new form type in the DB
# ---------------------------------------------------------------------------

class TestNewFormsPipeline(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.db = _make_db()

    @classmethod
    def tearDownClass(cls):
        cls.db.close()

    def setUp(self):
        self.db.cursor.executescript(
            "DELETE FROM reported_data; DELETE FROM filing; DELETE FROM organization;"
        )

    def _run(self, xml):
        return _run_xml(xml, self.db)

    def test_990ez_pipeline_stores_filing(self):
        result = self._run(VALID_990EZ_XML)
        self.assertEqual(result["status"], "stored")

    def test_990n_pipeline_stores_filing(self):
        result = self._run(VALID_990N_XML)
        self.assertEqual(result["status"], "stored")

    def test_990pf_pipeline_stores_filing(self):
        result = self._run(VALID_990PF_XML)
        self.assertEqual(result["status"], "stored")

    def test_990t_pipeline_stores_filing(self):
        result = self._run(VALID_990T_XML)
        self.assertEqual(result["status"], "stored")

    def test_990ez_correct_form_code(self):
        result = self._run(VALID_990EZ_XML)
        filing = self.db.filings.get_filing(result["filing_id"])
        self.assertEqual(filing["form_code"], "990EZ")

    def test_990n_correct_form_code(self):
        result = self._run(VALID_990N_XML)
        filing = self.db.filings.get_filing(result["filing_id"])
        self.assertEqual(filing["form_code"], "990N")

    def test_990pf_correct_form_code(self):
        result = self._run(VALID_990PF_XML)
        filing = self.db.filings.get_filing(result["filing_id"])
        self.assertEqual(filing["form_code"], "990PF")

    def test_990t_correct_form_code(self):
        result = self._run(VALID_990T_XML)
        filing = self.db.filings.get_filing(result["filing_id"])
        self.assertEqual(filing["form_code"], "990T")

    def test_990ez_stores_reported_data(self):
        result = self._run(VALID_990EZ_XML)
        self.assertGreater(result["fields_stored"], 0)

    def test_990pf_stores_reported_data(self):
        result = self._run(VALID_990PF_XML)
        self.assertGreater(result["fields_stored"], 0)

    def test_990t_stores_reported_data(self):
        result = self._run(VALID_990T_XML)
        self.assertGreater(result["fields_stored"], 0)

    def test_990ez_revenue_field_stored(self):
        result = self._run(VALID_990EZ_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        rev_row = next(
            (r for r in data if r["xml_path"] == "ReturnData/IRS990EZ/TotalRevenueAmt"),
            None
        )
        self.assertIsNotNone(rev_row)
        self.assertEqual(rev_row["value"], "176000")

    def test_990ez_expense_field_stored(self):
        result = self._run(VALID_990EZ_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        exp_row = next(
            (r for r in data if r["xml_path"] == "ReturnData/IRS990EZ/TotalExpensesAmt"),
            None
        )
        self.assertIsNotNone(exp_row)
        self.assertEqual(exp_row["value"], "140000")

    def test_990ez_net_assets_field_stored(self):
        result = self._run(VALID_990EZ_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        na_row = next(
            (r for r in data if r["xml_path"] == "ReturnData/IRS990EZ/NetAssetsOrFundBalancesEOYAmt"),
            None
        )
        self.assertIsNotNone(na_row)
        self.assertEqual(na_row["value"], "86000")

    def test_990pf_balance_sheet_stored(self):
        result = self._run(VALID_990PF_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        assets_row = next(
            (r for r in data if r["xml_path"] == "ReturnData/IRS990PF/TotalAssetsEOYAmt"),
            None
        )
        self.assertIsNotNone(assets_row)
        self.assertEqual(assets_row["value"], "5000000")

    def test_990t_ubi_field_stored(self):
        result = self._run(VALID_990T_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        ubi_row = next(
            (r for r in data if r["xml_path"] == "ReturnData/IRS990T/TotalGrossUBIAmt"),
            None
        )
        self.assertIsNotNone(ubi_row)
        self.assertEqual(ubi_row["value"], "300000")

    def test_990ez_org_created(self):
        self._run(VALID_990EZ_XML)
        org = self.db.orgs.get_organization("111111111")
        self.assertIsNotNone(org)
        self.assertEqual(org["name"], "Small Nonprofit EZ")

    def test_990n_org_created(self):
        self._run(VALID_990N_XML)
        org = self.db.orgs.get_organization("222222222")
        self.assertIsNotNone(org)

    def test_990pf_org_created(self):
        self._run(VALID_990PF_XML)
        org = self.db.orgs.get_organization("333333333")
        self.assertIsNotNone(org)

    def test_990t_org_created(self):
        self._run(VALID_990T_XML)
        org = self.db.orgs.get_organization("444444444")
        self.assertIsNotNone(org)

    def test_all_four_new_forms_in_one_db(self):
        for xml in [VALID_990EZ_XML, VALID_990N_XML, VALID_990PF_XML, VALID_990T_XML]:
            result = self._run(xml)
            self.assertEqual(result["status"], "stored")
        count = self.db.cursor.execute("SELECT COUNT(*) FROM filing").fetchone()[0]
        self.assertEqual(count, 4)

    def test_990ez_fields_include_correct_part_number(self):
        result = self._run(VALID_990EZ_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        part_i_rows = [r for r in data if r["part"]["number"] == "I"]
        self.assertGreater(len(part_i_rows), 0)

    def test_990pf_total_revenue_nested_path_stored(self):
        result = self._run(VALID_990PF_XML)
        data = self.db.reported_data.get_reported_data(result["filing_id"])
        rev_row = next(
            (r for r in data
             if "TotalRevAndExpnssGrp" in (r["xml_path"] or "")
             and "RevenueAndExpensesPerBooksAmt" in (r["xml_path"] or "")),
            None
        )
        self.assertIsNotNone(rev_row)
        self.assertEqual(rev_row["value"], "550000")


# ---------------------------------------------------------------------------
# Idempotency: populate.sql runs every startup without errors
# ---------------------------------------------------------------------------

class TestPopulateSqlIdempotent(unittest.TestCase):

    def test_second_db_init_does_not_raise(self):
        db = _make_db()
        db.close()
        db2 = _make_db()
        db2.close()

    def test_supported_forms_consistent_across_reinit(self):
        db1 = _make_db()
        forms1 = db1.meta.get_supported_forms()
        db1.close()
        db2 = _make_db()
        forms2 = db2.meta.get_supported_forms()
        db2.close()
        self.assertEqual(forms1, forms2)

    def test_field_count_consistent_across_reinit(self):
        db1 = _make_db()
        count1 = db1.cursor.execute("SELECT COUNT(*) FROM field").fetchone()[0]
        db1.close()
        db2 = _make_db()
        count2 = db2.cursor.execute("SELECT COUNT(*) FROM field").fetchone()[0]
        db2.close()
        self.assertEqual(count1, count2)


if __name__ == "__main__":
    unittest.main()
