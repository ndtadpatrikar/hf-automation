--Model Large Order Entry EQ(6),LOE FUT(49),OPT(103)

NSERT ignore INTO alertparametertype 
(ParameterTypeID, AlertTypeID, ParameterName, ValueDataType, RangeStart, RangeEnd, DefaultValue, SBParameterName, AuditID, OverrideTypeCode, TypeOfParameter, Source, ParameterVisibility, ParameterDescription)
VALUES
(4809, 6, 'Lookback Window Start Time', 'String', '0', '86400', '32400', 'LO_LookbackWindowStartTime', 3, 'N', 'Extract value from tuple', 'AlertSchema.ComputedFactors', 'N', NULL),
(4810, 6, 'Lookback Window End Time', 'String', '0', '86400', '32400', 'LO_LookbackWindowEndTime', 3, 'N', 'Extract value from tuple', 'AlertSchema.ComputedFactors', 'N', NULL),
(4811, 6, 'LookbackWindow Threshold', 'Int', '0', '86400', '60', 'LO_LookbackWindowThreshold', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'LookbackWindow threshold which is a number between 0 - 86400'),
(4812, 6, 'Net Order Aggregation Switch', 'Bool', '0', '1', '0', 'LO_NetOrderAggregationSwitch', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Net Order Aggregation Switch threshold which is a boolean'),
(4813, 6, 'Order Aggregation Switch', 'Bool', '0', '1', '0', 'LO_OrderAggregationSwitch', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Order Aggregation Switch threshold which is a boolean'),
(4814, 6, 'Min Time Between Qualified Events', 'Int', '0', '86400', '10', 'LO_MinTimeBetweenQualifiedEvent', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Min Time Between Qualified Events threshold which is a number between 0 - 86400'),
(4815, 6, 'Window Suppression Threshold', 'Double', '0', '1000', '10', 'LO_WindowSuppressionThreshold', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Window Suppression threshold which is a decimal number between 0.0 - 1000.0 %'),
(4816, 6, 'Message', 'String', '0', '86400', '32400', 'LO_CONDITIONAL_MESSAGE', 3, 'N', 'Extract value from tuple', 'AlertSchema.ComputedFactors', 'N', NULL),
(4837, 6, 'SecurityID', 'String', '', '', '', 'LO_SecurityID', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4838, 6, 'Calculated ADV Ratio', 'Percent', '0', '100', '10', 'LO_calculatedADVRatio', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4839, 49, 'SecurityID', 'String', '', '', '', 'FUTLO_SecurityID', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4840, 49, 'Calculated ADV Ratio', 'Percent', '0', '100', '10', 'FUTLO_calculatedADVRatio', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4841, 103, 'SecurityID', 'String', '', '', '', 'OPTLO_SecurityID', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4842, 103, 'Calculated ADV Ratio', 'Percent', '0', '100', '10', 'OPTLO_calculatedADVRatio', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL);
UPDATE alerttype SET AlertShortTemplate = 'Large order entry alert for Security LO_SecurityID with order volume to ADV ratio of LO_calculatedADVRatio breaching the Security ADV threshold of LO_InstrumentThreshold.' WHERE AlertTypeID = 6;
UPDATE alerttype SET AlertShortTemplate = 'Large order entry alert for Security FUTLO_SecurityID with order volume to ADV ratio of FUTLO_calculatedADVRatio breaching the Security ADV threshold of FUTLO_InstrumentThreshold.' WHERE AlertTypeID = 49;
UPDATE alerttype SET AlertShortTemplate = 'Large order entry alert for Security OPTLO_SecurityID with order volume to ADV ratio of OPTLO_calculatedADVRatio breaching the Security ADV threshold of OPTLO_InstrumentThreshold.' WHERE AlertTypeID = 103;
UPDATE alerttype SET AlertLongTemplate = 'Large order entry alert for Account LO_Account and Security LO_SecurityID. Large order volume to ADV ratio is LO_calculatedADVRatio which breaches the defined Security ADV Threshold of LO_InstrumentThreshold. LO_CONDITIONAL_MESSAGE.' WHERE AlertTypeID = 6;
UPDATE alerttype SET AlertLongTemplate = 'Large order entry alert for Account FUTLO_Account and Security FUTLO_SecurityID. Large order volume to ADV ratio is FUTLO_calculatedADVRatio which breaches the defined Security ADV Threshold of FUTLO_InstrumentThreshold. FUTLO_CONDITIONAL_MESSAGE.' WHERE AlertTypeID = 49;
UPDATE alerttype SET AlertLongTemplate = 'Large order entry alert for Account OPTLO_Account and Security OPTLO_SecurityID. Large order volume to ADV ratio is OPTLO_calculatedADVRatio which breaches the defined Security ADV Threshold of OPTLO_InstrumentThreshold. OPTLO_CONDITIONAL_MESSAGE.' WHERE AlertTypeID = 103;


