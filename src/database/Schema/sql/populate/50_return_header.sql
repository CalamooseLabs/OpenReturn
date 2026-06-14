-- Return Header — paths for graph-database relationship discovery.
-- Uses part 14 (defined in 10_form_990.sql); must load after it.

-- ========================================================================
-- RETURN HEADER — 52 paths for graph-database relationship discovery
-- Part 14 (990 EXT2), sections 13227–13235, lines 131838–131889
-- ========================================================================

-- Return Header / Direct Fields
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13227, 14, '178', 'Return Header Direct Fields');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131839, 13227, '2',  'Tax Period Begin Dt',            'TEXT'),
  (131840, 13227, '3',  'Tax Period End Dt',              'TEXT'),
  (131841, 13227, '4',  'Return Ts',                      'TEXT'),
  (131842, 13227, '5',  'Build TS',                       'TEXT'),
  (131844, 13227, '7',  'IRS Responsible Prty Info Curr Ind', 'BOOLEAN'),
  (131845, 13227, '8',  'Form8822 B Attached Ind',        'BOOLEAN'),
  (131846, 13227, '9',  'Disaster Relief Txt',            'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131839, NULL, NULL, 'Tax Period Begin Dt',            'TEXT',    'ReturnHeader/TaxPeriodBeginDt'),
  (131840, NULL, NULL, 'Tax Period End Dt',              'TEXT',    'ReturnHeader/TaxPeriodEndDt'),
  (131841, NULL, NULL, 'Return Ts',                      'TEXT',    'ReturnHeader/ReturnTs'),
  (131842, NULL, NULL, 'Build TS',                       'TEXT',    'ReturnHeader/BuildTS'),
  (131844, NULL, NULL, 'IRS Responsible Prty Info Curr Ind', 'BOOLEAN', 'ReturnHeader/IRSResponsiblePrtyInfoCurrInd'),
  (131845, NULL, NULL, 'Form8822 B Attached Ind',        'BOOLEAN', 'ReturnHeader/Form8822BAttachedInd'),
  (131846, NULL, NULL, 'Disaster Relief Txt',            'TEXT',    'ReturnHeader/DisasterReliefTxt');

-- Return Header / Filer Info
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13228, 14, '179', 'Filer Info');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131849, 13228, '3', 'Business Name Line2 Txt',      'TEXT'),
  (131850, 13228, '4', 'Business Name Control Txt',    'TEXT'),
  (131851, 13228, '5', 'In Care Of Nm',                'TEXT'),
  (131852, 13228, '6', 'Phone Num',                    'TEXT'),
  (131853, 13228, '7', 'Foreign Phone Num',            'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131849, NULL, NULL, 'Business Name Line2 Txt',      'TEXT', 'ReturnHeader/Filer/BusinessName/BusinessNameLine2Txt'),
  (131850, NULL, NULL, 'Business Name Control Txt',    'TEXT', 'ReturnHeader/Filer/BusinessNameControlTxt'),
  (131851, NULL, NULL, 'In Care Of Nm',                'TEXT', 'ReturnHeader/Filer/InCareOfNm'),
  (131852, NULL, NULL, 'Phone Num',                    'TEXT', 'ReturnHeader/Filer/PhoneNum'),
  (131853, NULL, NULL, 'Foreign Phone Num',            'TEXT', 'ReturnHeader/Filer/ForeignPhoneNum');

-- Return Header / Filer US Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13229, 14, '180', 'Filer US Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131854, 13229, '1', 'Address Line1 Txt',         'TEXT'),
  (131855, 13229, '2', 'City Nm',                   'TEXT'),
  (131856, 13229, '3', 'State Abbreviation Cd',     'TEXT'),
  (131857, 13229, '4', 'ZIP Cd',                    'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131854, NULL, NULL, 'Address Line1 Txt',         'TEXT', 'ReturnHeader/Filer/USAddress/AddressLine1Txt'),
  (131855, NULL, NULL, 'City Nm',                   'TEXT', 'ReturnHeader/Filer/USAddress/CityNm'),
  (131856, NULL, NULL, 'State Abbreviation Cd',     'TEXT', 'ReturnHeader/Filer/USAddress/StateAbbreviationCd'),
  (131857, NULL, NULL, 'ZIP Cd',                    'TEXT', 'ReturnHeader/Filer/USAddress/ZIPCd');

-- Return Header / Filer Foreign Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13230, 14, '181', 'Filer Foreign Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131858, 13230, '1', 'Address Line1 Txt',         'TEXT'),
  (131859, 13230, '2', 'City Nm',                   'TEXT'),
  (131860, 13230, '3', 'Country Cd',                'TEXT'),
  (131861, 13230, '4', 'Foreign Postal Cd',         'TEXT'),
  (131862, 13230, '5', 'Province Or State Nm',      'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131858, NULL, NULL, 'Address Line1 Txt',         'TEXT', 'ReturnHeader/Filer/ForeignAddress/AddressLine1Txt'),
  (131859, NULL, NULL, 'City Nm',                   'TEXT', 'ReturnHeader/Filer/ForeignAddress/CityNm'),
  (131860, NULL, NULL, 'Country Cd',                'TEXT', 'ReturnHeader/Filer/ForeignAddress/CountryCd'),
  (131861, NULL, NULL, 'Foreign Postal Cd',         'TEXT', 'ReturnHeader/Filer/ForeignAddress/ForeignPostalCd'),
  (131862, NULL, NULL, 'Province Or State Nm',      'TEXT', 'ReturnHeader/Filer/ForeignAddress/ProvinceOrStateNm');

-- Return Header / Business Officer Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13231, 14, '182', 'Business Officer Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131863, 13231, '1', 'Person Nm',                         'TEXT'),
  (131864, 13231, '2', 'Person Title Txt',                  'TEXT'),
  (131865, 13231, '3', 'Phone Num',                         'TEXT'),
  (131866, 13231, '4', 'Foreign Phone Num',                 'TEXT'),
  (131867, 13231, '5', 'Signature Dt',                      'TEXT'),
  (131868, 13231, '6', 'Discuss With Paid Preparer Ind',    'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131863, NULL, NULL, 'Person Nm',                         'TEXT',    'ReturnHeader/BusinessOfficerGrp/PersonNm'),
  (131864, NULL, NULL, 'Person Title Txt',                  'TEXT',    'ReturnHeader/BusinessOfficerGrp/PersonTitleTxt'),
  (131865, NULL, NULL, 'Phone Num',                         'TEXT',    'ReturnHeader/BusinessOfficerGrp/PhoneNum'),
  (131866, NULL, NULL, 'Foreign Phone Num',                 'TEXT',    'ReturnHeader/BusinessOfficerGrp/ForeignPhoneNum'),
  (131867, NULL, NULL, 'Signature Dt',                      'TEXT',    'ReturnHeader/BusinessOfficerGrp/SignatureDt'),
  (131868, NULL, NULL, 'Discuss With Paid Preparer Ind',    'BOOLEAN', 'ReturnHeader/BusinessOfficerGrp/DiscussWithPaidPreparerInd');

-- Return Header / Preparer Person Grp
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13232, 14, '183', 'Preparer Person Grp');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131869, 13232, '1', 'Preparer Person Nm',    'TEXT'),
  (131870, 13232, '2', 'PTIN',                  'TEXT'),
  (131871, 13232, '3', 'SSN',                   'TEXT'),
  (131872, 13232, '4', 'Phone Num',             'TEXT'),
  (131873, 13232, '5', 'Foreign Phone Num',     'TEXT'),
  (131874, 13232, '6', 'Preparation Dt',        'TEXT'),
  (131875, 13232, '7', 'Self Employed Ind',     'BOOLEAN');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131869, NULL, NULL, 'Preparer Person Nm',    'TEXT',    'ReturnHeader/PreparerPersonGrp/PreparerPersonNm'),
  (131870, NULL, NULL, 'PTIN',                  'TEXT',    'ReturnHeader/PreparerPersonGrp/PTIN'),
  (131871, NULL, NULL, 'SSN',                   'TEXT',    'ReturnHeader/PreparerPersonGrp/SSN'),
  (131872, NULL, NULL, 'Phone Num',             'TEXT',    'ReturnHeader/PreparerPersonGrp/PhoneNum'),
  (131873, NULL, NULL, 'Foreign Phone Num',     'TEXT',    'ReturnHeader/PreparerPersonGrp/ForeignPhoneNum'),
  (131874, NULL, NULL, 'Preparation Dt',        'TEXT',    'ReturnHeader/PreparerPersonGrp/PreparationDt'),
  (131875, NULL, NULL, 'Self Employed Ind',     'BOOLEAN', 'ReturnHeader/PreparerPersonGrp/SelfEmployedInd');

-- Return Header / Preparer Firm Info
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13233, 14, '184', 'Preparer Firm Info');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131876, 13233, '1', 'Preparer Firm EIN',            'TEXT'),
  (131877, 13233, '2', 'Preparer Firm Name Line1 Txt', 'TEXT'),
  (131878, 13233, '3', 'Preparer Firm Name Line2 Txt', 'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131876, NULL, NULL, 'Preparer Firm EIN',            'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerFirmEIN'),
  (131877, NULL, NULL, 'Preparer Firm Name Line1 Txt', 'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerFirmName/BusinessNameLine1Txt'),
  (131878, NULL, NULL, 'Preparer Firm Name Line2 Txt', 'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerFirmName/BusinessNameLine2Txt');

-- Return Header / Preparer Firm US Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13234, 14, '185', 'Preparer Firm US Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131879, 13234, '1', 'Address Line1 Txt',         'TEXT'),
  (131880, 13234, '2', 'Address Line2 Txt',         'TEXT'),
  (131881, 13234, '3', 'City Nm',                   'TEXT'),
  (131882, 13234, '4', 'State Abbreviation Cd',     'TEXT'),
  (131883, 13234, '5', 'ZIP Cd',                    'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131879, NULL, NULL, 'Address Line1 Txt',         'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerUSAddress/AddressLine1Txt'),
  (131880, NULL, NULL, 'Address Line2 Txt',         'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerUSAddress/AddressLine2Txt'),
  (131881, NULL, NULL, 'City Nm',                   'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerUSAddress/CityNm'),
  (131882, NULL, NULL, 'State Abbreviation Cd',     'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerUSAddress/StateAbbreviationCd'),
  (131883, NULL, NULL, 'ZIP Cd',                    'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerUSAddress/ZIPCd');

-- Return Header / Preparer Firm Foreign Address
INSERT OR IGNORE INTO
  section (section_id, part_id, section_code, section_name)
VALUES
  (13235, 14, '186', 'Preparer Firm Foreign Address');
INSERT OR IGNORE INTO
  line (line_id, section_id, line_number, line_label, data_type)
VALUES
  (131884, 13235, '1', 'Address Line1 Txt',         'TEXT'),
  (131885, 13235, '2', 'Address Line2 Txt',         'TEXT'),
  (131886, 13235, '3', 'City Nm',                   'TEXT'),
  (131887, 13235, '4', 'Country Cd',                'TEXT'),
  (131888, 13235, '5', 'Foreign Postal Cd',         'TEXT'),
  (131889, 13235, '6', 'Province Or State Nm',      'TEXT');
INSERT OR IGNORE INTO
  field (line_id, sub_letter, column_code, box_label, data_type, xml_path)
VALUES
  (131884, NULL, NULL, 'Address Line1 Txt',         'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/AddressLine1Txt'),
  (131885, NULL, NULL, 'Address Line2 Txt',         'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/AddressLine2Txt'),
  (131886, NULL, NULL, 'City Nm',                   'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/CityNm'),
  (131887, NULL, NULL, 'Country Cd',                'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/CountryCd'),
  (131888, NULL, NULL, 'Foreign Postal Cd',         'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/ForeignPostalCd'),
  (131889, NULL, NULL, 'Province Or State Nm',      'TEXT', 'ReturnHeader/PreparerFirmGrp/PreparerForeignAddress/ProvinceOrStateNm');
