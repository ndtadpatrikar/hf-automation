-- QST Smoking Enhancement for Equities,Futures,Options
INSERT IGNORE INTO `alertparametertype`
(`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`,
`TypeOfParameter`, `Source`, `ParameterVisibility`,`ParameterDescription`)
VALUES
(4845, 21, 'Smoking Activity', 'Bool', '0', '1', '0', 'ESQS_SmokingActivity', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Smoking Activity threshold which is a boolean'),
(4846, 61, 'Smoking Activity', 'Bool', '0', '1', '0', 'FUTESQS_SmokingActivity', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Smoking Activity threshold which is a boolean'),
(4847, 106, 'Smoking Activity', 'Bool', '0', '1', '0', 'OPTESQS_SmokingActivity', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Smoking Activity threshold which is a boolean'),
(4848, 21, 'Potential Smoking Activity', 'String', '', '', '', 'ESQS_SmokingAnalytics', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4849, 61, 'Potential Smoking Activity', 'String', '', '', '', 'FUTESQS_SmokingAnalytics', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4850, 106, 'Potential Smoking Activity', 'String', '', '', '', 'OPTESQS_SmokingAnalytics', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL);