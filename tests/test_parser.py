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

    def test_upper_boundary_split(self):
        # "XMLFile": when curr and prev are both upper but next is lower (F→i),
        # the word splits: "XML" + "File"
        self.assertEqual(self._split("XMLFile"), "XML File")

    def test_upper_boundary_split_usa(self):
        # "USAOrg": split at O (prev=A upper, curr=O upper, next=r lower)
        self.assertEqual(self._split("USAOrg"), "USA Org")


class TestIRS990ParserDict(unittest.TestCase):

    def test_dict_returns_dict(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict()
        self.assertIsInstance(result, dict)

    def test_dict_unlimited_depth_has_return_key(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict()
        self.assertIn("Return", result)

    def test_dict_node_has_text_and_children(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict()
        root_node = result["Return"]
        self.assertIn("text", root_node)
        self.assertIn("children", root_node)

    def test_dict_children_is_list(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict()
        self.assertIsInstance(result["Return"]["children"], list)

    def test_dict_depth_1_has_no_grandchildren(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict(depth=1)
        root_children = result["Return"]["children"]
        self.assertEqual(root_children, [])

    def test_dict_depth_2_has_children(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict(depth=2)
        root_children = result["Return"]["children"]
        self.assertGreater(len(root_children), 0)

    def test_dict_strips_irs_namespace_from_tags(self):
        parser = IRS990Parser(VALID_990_XML)
        result = parser.dict()
        # Top-level key should be plain "Return", not "{http://...}Return"
        keys = list(result.keys())
        self.assertFalse(any('{' in k for k in keys))


if __name__ == "__main__":
    unittest.main()
