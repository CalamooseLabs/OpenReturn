import sys
import os
import unittest
import xml.etree.ElementTree as ET

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from router.Filing.filing import _render


_FIELD = {
    "part":      {"number": "1"},
    "section":   {"code": "A"},
    "line":      {"number": "2", "label": "Line Label"},
    "sub_letter": None,
    "box_label": "Box Label",
    "value":     "Field Value",
}

_FIELD_NONE_SECTION = {
    "part":      {"number": "3"},
    "section":   {"code": "NONE"},
    "line":      {"number": "5", "label": "Revenue"},
    "sub_letter": "a",
    "box_label": None,
    "value":     "12345",
}

_RESULT = {
    "filing_id":    "uuid-abc-123",
    "ein":          "111111111",
    "year":         2023,
    "form_code":    "990",
    "xml_filename": "filing.xml",
    "zip_filename": "2023.zip",
    "fields":       [_FIELD],
}

_RESULT_EMPTY = {**_RESULT, "fields": []}


# ---------------------------------------------------------------------------
# JSON / unknown format (pass-through)
# ---------------------------------------------------------------------------

class TestRenderJson(unittest.TestCase):

    def test_json_returns_dict(self):
        self.assertIsInstance(_render(_RESULT, 'json'), dict)

    def test_json_returns_result_unchanged(self):
        self.assertIs(_render(_RESULT, 'json'), _RESULT)

    def test_unknown_format_returns_dict(self):
        self.assertIsInstance(_render(_RESULT, 'csv'), dict)

    def test_empty_format_returns_dict(self):
        self.assertIsInstance(_render(_RESULT, ''), dict)


# ---------------------------------------------------------------------------
# Markdown format
# ---------------------------------------------------------------------------

class TestRenderMarkdown(unittest.TestCase):

    def setUp(self):
        self.output = _render(_RESULT, 'md')

    def test_returns_string(self):
        self.assertIsInstance(self.output, str)

    def test_starts_with_heading(self):
        self.assertTrue(self.output.startswith('#'))

    def test_heading_contains_ein(self):
        self.assertIn("111111111", self.output)

    def test_heading_contains_year(self):
        self.assertIn("2023", self.output)

    def test_heading_contains_form_code(self):
        self.assertIn("990", self.output)

    def test_heading_contains_filing_id(self):
        self.assertIn("uuid-abc-123", self.output)

    def test_has_column_header_row(self):
        self.assertIn("| Part |", self.output)

    def test_has_separator_row(self):
        self.assertIn("| --- |", self.output)

    def test_has_field_value(self):
        self.assertIn("Field Value", self.output)

    def test_uses_box_label_when_present(self):
        self.assertIn("Box Label", self.output)

    def test_uses_line_label_when_no_box_label(self):
        field = {**_FIELD, "box_label": None}
        output = _render({**_RESULT, "fields": [field]}, 'md')
        self.assertIn("Line Label", output)

    def test_none_section_becomes_empty_cell(self):
        output = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'md')
        data_rows = [
            l for l in output.splitlines()
            if l.startswith('|') and '---' not in l and 'Part' not in l
        ]
        section_cell = data_rows[0].split('|')[2].strip()
        self.assertEqual(section_cell, '')

    def test_sub_letter_appended_to_line_number(self):
        output = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'md')
        self.assertIn("5a", output)

    def test_pipe_in_value_escaped(self):
        field = {**_FIELD, "value": "foo|bar"}
        output = _render({**_RESULT, "fields": [field]}, 'md')
        self.assertIn(r"foo\|bar", output)

    def test_empty_fields_yields_only_header_and_separator(self):
        output = _render(_RESULT_EMPTY, 'md')
        pipe_lines = [l for l in output.splitlines() if l.startswith('|')]
        self.assertEqual(len(pipe_lines), 2)


# ---------------------------------------------------------------------------
# HTML format
# ---------------------------------------------------------------------------

class TestRenderHtml(unittest.TestCase):

    def setUp(self):
        self.output = _render(_RESULT, 'html')

    def test_returns_string(self):
        self.assertIsInstance(self.output, str)

    def test_has_heading_tag(self):
        self.assertIn('<h3>', self.output)

    def test_heading_contains_ein(self):
        self.assertIn("111111111", self.output)

    def test_heading_contains_year(self):
        self.assertIn("2023", self.output)

    def test_has_table_tag(self):
        self.assertIn('<table', self.output)

    def test_has_thead(self):
        self.assertIn('<thead>', self.output)

    def test_has_th_elements(self):
        self.assertIn('<th>', self.output)

    def test_has_tbody(self):
        self.assertIn('<tbody>', self.output)

    def test_has_field_value_in_td(self):
        self.assertIn('Field Value', self.output)

    def test_uses_box_label_when_present(self):
        self.assertIn("Box Label", self.output)

    def test_uses_line_label_when_no_box_label(self):
        field = {**_FIELD, "box_label": None}
        output = _render({**_RESULT, "fields": [field]}, 'html')
        self.assertIn("Line Label", output)

    def test_none_section_becomes_empty_td(self):
        output = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'html')
        self.assertIn('<td></td>', output)

    def test_sub_letter_appended_to_line_number(self):
        output = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'html')
        self.assertIn("5a", output)


# ---------------------------------------------------------------------------
# XML format
# ---------------------------------------------------------------------------

def _parse(xml_str: str) -> ET.Element:
    return ET.fromstring(xml_str)


class TestRenderXml(unittest.TestCase):

    def setUp(self):
        self.xml_str, self.content_type = _render(_RESULT, 'xml')
        self.root = _parse(self.xml_str)

    def test_returns_tuple(self):
        self.assertIsInstance(_render(_RESULT, 'xml'), tuple)

    def test_content_type_is_application_xml(self):
        self.assertEqual(self.content_type, 'application/xml')

    def test_body_is_string(self):
        self.assertIsInstance(self.xml_str, str)

    def test_starts_with_xml_declaration(self):
        self.assertTrue(self.xml_str.startswith('<?xml version="1.0" encoding="UTF-8"?>'))

    def test_is_valid_xml(self):
        _parse(self.xml_str)  # raises if invalid

    def test_root_element_is_filing(self):
        self.assertEqual(self.root.tag, 'filing')

    def test_ein_element(self):
        self.assertEqual(self.root.findtext('ein'), '111111111')

    def test_year_element(self):
        self.assertEqual(self.root.findtext('year'), '2023')

    def test_form_code_element(self):
        self.assertEqual(self.root.findtext('form_code'), '990')

    def test_filing_id_element(self):
        self.assertEqual(self.root.findtext('filing_id'), 'uuid-abc-123')

    def test_xml_filename_element(self):
        self.assertEqual(self.root.findtext('xml_filename'), 'filing.xml')

    def test_zip_filename_element(self):
        self.assertEqual(self.root.findtext('zip_filename'), '2023.zip')

    def test_fields_element_present(self):
        self.assertIsNotNone(self.root.find('fields'))

    def test_one_field_child(self):
        self.assertEqual(len(self.root.find('fields')), 1)

    def test_field_part(self):
        self.assertEqual(self.root.findtext('fields/field/part'), '1')

    def test_field_section(self):
        self.assertEqual(self.root.findtext('fields/field/section'), 'A')

    def test_field_line(self):
        self.assertEqual(self.root.findtext('fields/field/line'), '2')

    def test_field_description_uses_box_label(self):
        self.assertEqual(self.root.findtext('fields/field/description'), 'Box Label')

    def test_field_value(self):
        self.assertEqual(self.root.findtext('fields/field/value'), 'Field Value')

    def test_none_section_becomes_empty_string(self):
        xml_str, _ = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'xml')
        root = _parse(xml_str)
        self.assertEqual(root.findtext('fields/field/section'), '')

    def test_sub_letter_appended_to_line(self):
        xml_str, _ = _render({**_RESULT, "fields": [_FIELD_NONE_SECTION]}, 'xml')
        root = _parse(xml_str)
        self.assertEqual(root.findtext('fields/field/line'), '5a')

    def test_line_label_used_when_no_box_label(self):
        field = {**_FIELD, "box_label": None}
        xml_str, _ = _render({**_RESULT, "fields": [field]}, 'xml')
        root = _parse(xml_str)
        self.assertEqual(root.findtext('fields/field/description'), 'Line Label')

    def test_special_chars_escaped_in_value(self):
        field = {**_FIELD, "value": "<foo>&bar"}
        xml_str, _ = _render({**_RESULT, "fields": [field]}, 'xml')
        root = _parse(xml_str)
        self.assertEqual(root.findtext('fields/field/value'), '<foo>&bar')

    def test_empty_fields_has_empty_fields_element(self):
        xml_str, _ = _render(_RESULT_EMPTY, 'xml')
        root = _parse(xml_str)
        self.assertEqual(len(root.find('fields')), 0)


if __name__ == "__main__":
    unittest.main()
