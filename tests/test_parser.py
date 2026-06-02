import sys
import os
import unittest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from parser.IRS990 import IRS990Parser
from tests.fixtures import VALID_990_XML


class TestIRS990ParserGetElem(unittest.TestCase):
    def setUp(self):
        self.parser = IRS990Parser(VALID_990_XML)

    def test_returns_text_for_shallow_path(self):
        self.assertEqual(self.parser.getElem("ReturnHeader/TaxYr"), "2023")

    def test_returns_text_for_deep_path(self):
        self.assertEqual(
            self.parser.getElem("ReturnHeader/Filer/BusinessName/BusinessNameLine1Txt"),
            "Test Org",
        )

    def test_returns_text_under_returndata(self):
        self.assertEqual(
            self.parser.getElem("ReturnData/IRS990/ActivityOrMissionDesc"),
            "Test mission",
        )

    def test_returns_none_for_missing_path(self):
        self.assertIsNone(self.parser.getElem("ReturnHeader/DoesNotExist"))

    def test_returns_none_for_wrong_root(self):
        self.assertIsNone(self.parser.getElem("WrongRoot/TaxYr"))


class TestIRS990ParserInstanceIsolation(unittest.TestCase):
    def test_instances_do_not_share_found_elements(self):
        p1 = IRS990Parser(VALID_990_XML)
        p2 = IRS990Parser(VALID_990_XML)
        self.assertIsNot(p1.foundElements, p2.foundElements)

    def test_second_instance_unaffected_by_first(self):
        p1 = IRS990Parser(VALID_990_XML)
        p1.getElem("ReturnHeader/TaxYr")

        p2 = IRS990Parser(VALID_990_XML)
        self.assertEqual(p2.getElem("ReturnHeader/TaxYr"), "2023")

    def test_found_elements_tracks_seen_paths(self):
        parser = IRS990Parser(VALID_990_XML)
        parser.getElem("ReturnHeader/TaxYr")
        self.assertIn("ReturnHeader/TaxYr", parser.foundElements)

    def test_unseen_path_not_in_found_elements(self):
        parser = IRS990Parser(VALID_990_XML)
        self.assertNotIn("ReturnHeader/TaxYr", parser.foundElements)


class TestIRS990ParserCleanTags(unittest.TestCase):
    def setUp(self):
        self.parser = IRS990Parser(VALID_990_XML)

    def _split(self, tag):
        return list(self.parser.cleanTags({tag: "v"}).keys())[0]

    def test_camelcase_with_digit(self):
        self.assertEqual(self._split("BusinessNameLine1Txt"), "Business Name Line 1Txt")

    def test_simple_two_words(self):
        self.assertEqual(self._split("TaxYr"), "Tax Yr")

    def test_three_words(self):
        self.assertEqual(self._split("GrossReceiptsAmt"), "Gross Receipts Amt")

    def test_four_words(self):
        self.assertEqual(self._split("ContractTerminationInd"), "Contract Termination Ind")

    def test_all_caps_abbreviation_unchanged(self):
        self.assertEqual(self._split("EIN"), "EIN")

    def test_preserves_values(self):
        result = self.parser.cleanTags({"TaxYr": "2023", "ReturnTypeCd": "990"})
        self.assertEqual(set(result.values()), {"2023", "990"})

    def test_empty_dict(self):
        self.assertEqual(self.parser.cleanTags({}), {})


if __name__ == "__main__":
    unittest.main()
