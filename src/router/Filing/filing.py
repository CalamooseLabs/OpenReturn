import sqlite3
import xml.etree.ElementTree as ET
from typing import Any
from http.client import HTTPMessage

from router import Router
from database import OpenReturnDB


def _render(result: dict, fmt: str) -> dict | str:
    if fmt not in ('md', 'html', 'xml'):
        return result

    fields = result.get('fields', [])
    meta = (
        f"EIN: {result.get('ein')}  |  "
        f"Year: {result.get('year')}  |  "
        f"Form: {result.get('form_code')}  |  "
        f"Filing: {result.get('filing_id')}"
    )
    cols = ['Part', 'Section', 'Line', 'Description', 'Value']
    rows = [
        [
            f['part']['number'],
            f['section']['code'] if f['section']['code'] != 'NONE' else '',
            f['line']['number'] + (f['sub_letter'] or ''),
            f['box_label'] or f['line']['label'] or '',
            f['value'] or '',
        ]
        for f in fields
    ]

    if fmt == 'md':
        h   = '| ' + ' | '.join(cols) + ' |'
        sep = '| ' + ' | '.join('---' for _ in cols) + ' |'
        data = [
            '| ' + ' | '.join(str(c).replace('|', '\\|') for c in row) + ' |'
            for row in rows
        ]
        return f"# {meta}\n\n" + '\n'.join([h, sep] + data)

    if fmt == 'xml':
        root = ET.Element('filing')
        for key in ('filing_id', 'ein', 'year', 'form_code', 'xml_filename', 'zip_filename'):
            val = result.get(key)
            if val is not None:
                ET.SubElement(root, key).text = str(val)
        fields_el = ET.SubElement(root, 'fields')
        for f in fields:
            field_el = ET.SubElement(fields_el, 'field')
            ET.SubElement(field_el, 'part').text    = str(f['part']['number'])
            ET.SubElement(field_el, 'section').text = f['section']['code'] if f['section']['code'] != 'NONE' else ''
            ET.SubElement(field_el, 'line').text    = f['line']['number'] + (f['sub_letter'] or '')
            ET.SubElement(field_el, 'description').text = f['box_label'] or f['line']['label'] or ''
            ET.SubElement(field_el, 'value').text   = f['value'] or ''
        ET.indent(root, space='  ')
        return '<?xml version="1.0" encoding="UTF-8"?>\n' + ET.tostring(root, encoding='unicode'), 'application/xml'

    th  = ''.join(f'<th>{c}</th>' for c in cols)
    trs = ''.join(
        '<tr>' + ''.join(f'<td>{c}</td>' for c in row) + '</tr>'
        for row in rows
    )
    return (
        f'<h3>{meta}</h3>'
        f'<table border="1" cellpadding="4" cellspacing="0" style="border-collapse:collapse">'
        f'<thead><tr>{th}</tr></thead><tbody>{trs}</tbody></table>'
    )


class FilingRouter(Router):
  def __init__(self, prefix: str = '/filings', db: OpenReturnDB = None, secure_by_default: bool = False) -> None:
    super().__init__(prefix, secure_by_default=secure_by_default)
    self.db = db
    self._register_routes()

  def _register_routes(self):

    @self.get('')
    def list_filings(query_params: dict, body: Any, headers: HTTPMessage):
      ein = self._qp(query_params, 'ein')
      if not ein:
        return {"error": "missing query param: ein"}
      return {"filings": self.db.filings.list_filings(ein)}

    @self.get('/detail')
    def get_filing(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = self._qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      filing = self.db.filings.get_filing(filing_id)
      if filing is None:
        return {"error": f"filing not found: {filing_id}"}
      return filing

    @self.post('')
    def create_filing(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'ein', 'year', 'form_code')
      if err:
        return err
      try:
        filing_id = self.db.filings.create_filing(data['ein'], int(data['year']), data['form_code'])
        self.db.commit()
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"filing_id": filing_id}

    @self.get('/data')
    def get_reported_data(query_params: dict, body: Any, headers: HTTPMessage):
      filing_id = self._qp(query_params, 'filing_id')
      if not filing_id:
        return {"error": "missing query param: filing_id"}
      fmt = (self._qp(query_params, 'format') or 'json').lower()
      filing = self.db.filings.get_filing(filing_id)
      if filing is None:
        return {"error": f"filing not found: {filing_id}"}
      result = {
        "filing_id":    filing_id,
        "ein":          filing['ein'],
        "year":         filing['year'],
        "form_code":    filing['form_code'],
        "xml_filename": filing['xml_filename'],
        "zip_filename": filing['zip_filename'],
        "fields":       self.db.reported_data.get_reported_data(filing_id),
      }
      return _render(result, fmt)

    @self.post('/data')
    def store_reported_data(query_params: dict, body: Any, headers: HTTPMessage):
      data, err = self._require_fields(body, 'filing_id', 'values')
      if err:
        return err
      if not isinstance(data['values'], dict):
        return {"error": "values must be a dict mapping field_id to raw_value"}
      try:
        values = {int(k): v for k, v in data['values'].items()}
        self.db.reported_data.store_reported_data(data['filing_id'], values)
        self.db.commit()
      except (sqlite3.IntegrityError, ValueError) as e:
        return {"error": str(e)}
      return {"filing_id": data['filing_id'], "fields_stored": len(values)}

    @self.get('/lookup')
    def lookup_filing_by_ein_year(query_params: dict, body: Any, headers: HTTPMessage):
      ein  = self._qp(query_params, 'ein')
      year = self._qp(query_params, 'year')
      if not ein or not year:
        return {"error": "missing query params: ein, year"}
      year_int, err = self._qp_int_or_error(query_params, 'year', field='year')
      if err:
        return err
      fmt = (self._qp(query_params, 'format') or 'json').lower()
      result = self.db.filings.get_filing_data_by_ein_year(ein, year_int)
      if result is None:
        return {"error": f"no filing found for EIN {ein} in year {year}"}
      return _render(result, fmt)
