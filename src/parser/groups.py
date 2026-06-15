"""Repeating-group extraction for the graph layer.

The flat ``{path: text}`` walk in ``router/Upload/upload.py`` keeps only the first
occurrence of each XML path, so repeating groups (officers, grants, related orgs)
collapse to one. This module instead iterates EVERY instance of each repeating
container element and emits one record per occurrence — the rows that become the
graph's edges (see ``docs/development/graph-model.md``).

``extract_groups(root)`` takes an ``ElementTree`` root (``Parser.root``, the
``<Return>`` element) and is shared by BOTH ingest paths — the parallel worker
(``_parse_xml_task``) and the HTTP single-file path (``_process_xml``) — so the
two never diverge. It is namespace-agnostic (matches on local tag names), so it
needs no namespace map.

The :data:`REGISTRY` is the single source of truth for which containers are
extracted and how their leaves map to columns; add an entry to capture a new
repeating group.
"""

from __future__ import annotations

import xml.etree.ElementTree as ET

# IRS efile US vs Foreign address sub-elements (leaf local-names per branch).
_US_ADDR = {'street': 'AddressLine1Txt', 'street2': 'AddressLine2Txt',
            'city': 'CityNm', 'state_code': 'StateAbbreviationCd', 'zipcode': 'ZIPCd'}
_FOREIGN_ADDR = {'street': 'AddressLine1Txt', 'street2': 'AddressLine2Txt',
                 'city': 'CityNm', 'province': 'ProvinceOrStateNm',
                 'country_code': 'CountryCd', 'foreign_postal': 'ForeignPostalCd'}

# Each entry: a repeating container (local-name path under <Return>) -> how to turn
# each instance into a record. group_code is 1:1 with the container path (the
# idempotency key is (filing_id, group_code, occurrence_index)).
#   kind:    'person_role' | 'grant' | 'related_org'
#   names:   {person_name|business_name: relative leaf path}
#   ein:     relative leaf path of the recipient/related EIN (soft link), if any
#   texts/reals/bools: edge-column -> relative leaf path (parsed accordingly)
#   address: (us_element, foreign_element) local-names, or None if the group has no address
#   tag:     a constant column value (grant_kind / relation_kind)
REGISTRY: list[dict] = [
    # ---- people: officers / directors / trustees / key employees ----
    {'group_code': 'F990_PART7A', 'kind': 'person_role',
     'container': ['ReturnData', 'IRS990', 'Form990PartVIISectionAGrp'],
     'names': {'person_name': 'PersonNm', 'business_name': 'BusinessName/BusinessNameLine1Txt'},
     'texts': {'title': 'TitleTxt'},
     'reals': {'avg_hours_org': 'AverageHoursPerWeekRt',
               'avg_hours_related': 'AverageHoursPerWeekRltdOrgRt',
               'reportable_comp_org': 'ReportableCompFromOrgAmt',
               'reportable_comp_related': 'ReportableCompFromRltdOrgAmt',
               'other_comp': 'OtherCompensationAmt'},
     'bools': {'is_officer': 'OfficerInd',
               'is_director_trustee': 'IndividualTrusteeOrDirectorInd',
               'is_key_employee': 'KeyEmployeeInd',
               'is_highest_comp': 'HighestCompensatedEmployeeInd',
               'is_former': 'FormerOfcrDirectorTrusteeInd'},
     'address': None},
    {'group_code': 'F990EZ_OFFICERS', 'kind': 'person_role',
     'container': ['ReturnData', 'IRS990EZ', 'OfficerDirectorTrusteeEmplGrp'],
     'names': {'person_name': 'PersonNm', 'business_name': 'BusinessName/BusinessNameLine1Txt'},
     'texts': {'title': 'TitleTxt'},
     'reals': {'avg_hours_org': 'AverageHrsPerWkDevotedToPosRt',
               'reportable_comp_org': 'CompensationAmt',
               'other_comp': 'ExpenseAccountOtherAllwncAmt'},
     'address': None},
    {'group_code': 'F990PF_OFFICERS', 'kind': 'person_role',
     'container': ['ReturnData', 'IRS990PF', 'OfficerDirTrstKeyEmplInfoGrp', 'OfficerDirTrstKeyEmplGrp'],
     'names': {'person_name': 'PersonNm', 'business_name': 'BusinessName/BusinessNameLine1Txt'},
     'texts': {'title': 'TitleTxt'},
     'reals': {'avg_hours_org': 'AverageHrsPerWkDevotedToPosRt',
               'reportable_comp_org': 'CompensationAmt',
               'other_comp': 'ExpenseAccountOtherAllwncAmt'},
     'address': ('USAddress', 'ForeignAddress')},

    # ---- grants: PF (no EIN) + Schedule I (EIN) ----
    {'group_code': 'PF_GRANT_PAID', 'kind': 'grant', 'tag': 'PF_PAID',
     'container': ['ReturnData', 'IRS990PF', 'SupplementaryInformationGrp', 'GrantOrContributionPdDurYrGrp'],
     'names': {'person_name': 'RecipientPersonNm', 'business_name': 'RecipientBusinessName/BusinessNameLine1Txt'},
     'reals': {'cash_amount': 'Amt'},
     'texts': {'purpose_txt': 'GrantOrContributionPurposeTxt',
               'recipient_relationship': 'RecipientRelationshipTxt',
               'recipient_foundation_status': 'RecipientFoundationStatusTxt'},
     'address': ('RecipientUSAddress', 'RecipientForeignAddress')},
    {'group_code': 'PF_GRANT_APPROVED', 'kind': 'grant', 'tag': 'PF_APPROVED',
     'container': ['ReturnData', 'IRS990PF', 'SupplementaryInformationGrp', 'GrantOrContriApprvForFutGrp'],
     'names': {'person_name': 'RecipientPersonNm', 'business_name': 'RecipientBusinessName/BusinessNameLine1Txt'},
     'reals': {'cash_amount': 'Amt'},
     'texts': {'purpose_txt': 'GrantOrContributionPurposeTxt',
               'recipient_relationship': 'RecipientRelationshipTxt',
               'recipient_foundation_status': 'RecipientFoundationStatusTxt'},
     'address': ('RecipientUSAddress', 'RecipientForeignAddress')},
    {'group_code': 'SCHED_I_ORG', 'kind': 'grant', 'tag': 'SCHED_I_ORG',
     'container': ['ReturnData', 'IRS990ScheduleI', 'RecipientTable'],
     'names': {'business_name': 'RecipientBusinessName/BusinessNameLine1Txt'},
     'ein': 'RecipientEIN',
     'reals': {'cash_amount': 'CashGrantAmt', 'noncash_amount': 'NonCashAssistanceAmt'},
     'texts': {'purpose_txt': 'PurposeOfGrantTxt', 'irc_section': 'IRCSectionDesc'},
     'address': ('USAddress', 'ForeignAddress')},

    # ---- related organizations (Schedule R) ----
    {'group_code': 'SCHED_R_EXEMPT', 'kind': 'related_org', 'tag': 'SCHED_R_EXEMPT',
     'container': ['ReturnData', 'IRS990ScheduleR', 'IdRelatedTaxExemptOrgGrp'],
     'names': {'business_name': 'RelatedOrganizationName/BusinessNameLine1Txt'},
     'ein': 'EIN',
     'texts': {'primary_activities': 'PrimaryActivitiesTxt', 'legal_domicile': 'LegalDomicileStateCd'},
     'bools': {'control_ind': 'ControlledOrganizationInd'},
     'address': ('USAddress', 'ForeignAddress')},
    {'group_code': 'SCHED_R_PARTNERSHIP', 'kind': 'related_org', 'tag': 'SCHED_R_PARTNERSHIP',
     'container': ['ReturnData', 'IRS990ScheduleR', 'IdRelatedOrgTxblPartnershipGrp'],
     'names': {'business_name': 'RelatedOrganizationName/BusinessNameLine1Txt'},
     'ein': 'EIN',
     'reals': {'ownership_pct': 'OwnershipPct'},
     'texts': {'primary_activities': 'PrimaryActivitiesTxt', 'legal_domicile': 'LegalDomicileStateCd'},
     'address': None},
    {'group_code': 'SCHED_R_CORP_TRUST', 'kind': 'related_org', 'tag': 'SCHED_R_CORP_TRUST',
     'container': ['ReturnData', 'IRS990ScheduleR', 'IdRelatedOrgTxblCorpTrGrp'],
     'names': {'business_name': 'RelatedOrganizationName/BusinessNameLine1Txt'},
     'ein': 'EIN',
     'reals': {'ownership_pct': 'OwnershipPct'},
     'texts': {'primary_activities': 'PrimaryActivitiesTxt', 'legal_domicile': 'LegalDomicileStateCd'},
     'bools': {'control_ind': 'ControlledOrganizationInd'},
     'address': None},
    {'group_code': 'SCHED_R_DISREGARDED', 'kind': 'related_org', 'tag': 'SCHED_R_DISREGARDED',
     'container': ['ReturnData', 'IRS990ScheduleR', 'IdDisregardedEntitiesGrp'],
     'names': {'business_name': 'DisregardedEntityName/BusinessNameLine1Txt'},
     'ein': 'EIN',
     'texts': {'primary_activities': 'PrimaryActivitiesTxt', 'legal_domicile': 'LegalDomicileStateCd'},
     'address': None},
]

_TRUE = {'true', '1', 'x', 'yes'}
_FALSE = {'false', '0', 'no'}


def _local(tag: str) -> str:
    return tag.rsplit('}', 1)[-1]


def _descend(elems: list, name: str) -> list:
    out = []
    for e in elems:
        out.extend(c for c in e if _local(c.tag) == name)
    return out


def _leaf_text(elem: ET.Element, rel_path: str) -> str | None:
    """First descendant text at a '/'-delimited local-name path, or None."""
    cur = [elem]
    for name in rel_path.split('/'):
        cur = _descend(cur, name)
        if not cur:
            return None
    t = cur[0].text
    return t.strip() if t and t.strip() else None


def _real(elem: ET.Element, rel_path: str):
    raw = _leaf_text(elem, rel_path)
    if raw is None:
        return None
    try:
        return float(raw.replace(',', ''))
    except ValueError:
        return None


def _bool(elem: ET.Element, rel_path: str):
    raw = _leaf_text(elem, rel_path)
    if raw is None:
        return None
    low = raw.strip().lower()
    if low in _TRUE:
        return 1
    if low in _FALSE:
        return 0
    return None


def _address(container: ET.Element, spec: tuple | None) -> dict | None:
    if not spec:
        return None
    us_name, foreign_name = spec
    for elem in container:
        local = _local(elem.tag)
        if local == us_name:
            addr = {'address_kind': 'US'}
            addr.update({k: _leaf_text(elem, p) for k, p in _US_ADDR.items()})
            return addr if any(v for k, v in addr.items() if k != 'address_kind') else None
        if local == foreign_name:
            addr = {'address_kind': 'FOREIGN'}
            addr.update({k: _leaf_text(elem, p) for k, p in _FOREIGN_ADDR.items()})
            return addr if any(v for k, v in addr.items() if k != 'address_kind') else None
    return None


def _containers(root: ET.Element, path: list) -> list:
    cur = [root]
    for name in path:
        cur = _descend(cur, name)
    return cur


def extract_groups(root: ET.Element) -> list[dict]:
    """Return one record per repeating-group occurrence in the filing.

    Each record: ``{group_code, occurrence_index, kind, party_kind, person_name,
    business_name, ein, address, edge}`` where ``edge`` holds the kind-specific
    columns. Records with neither a person nor business name are skipped (an empty
    container instance is not a node).
    """
    records: list[dict] = []
    for spec in REGISTRY:
        for idx, container in enumerate(_containers(root, spec['container'])):
            names = {k: _leaf_text(container, p) for k, p in spec['names'].items()}
            person_name = names.get('person_name')
            business_name = names.get('business_name')
            if not person_name and not business_name:
                continue
            ein = _leaf_text(container, spec['ein']) if spec.get('ein') else None
            edge: dict = {}
            for col, p in spec.get('texts', {}).items():
                edge[col] = _leaf_text(container, p)
            for col, p in spec.get('reals', {}).items():
                edge[col] = _real(container, p)
            for col, p in spec.get('bools', {}).items():
                edge[col] = _bool(container, p)
            if 'tag' in spec:
                edge['tag'] = spec['tag']
            records.append({
                'group_code': spec['group_code'],
                'occurrence_index': idx,
                'kind': spec['kind'],
                'party_kind': 'person' if person_name and not business_name else 'organization',
                'person_name': person_name,
                'business_name': business_name,
                'ein': ein,
                'address': _address(container, spec.get('address')),
                'edge': edge,
            })
    return records
