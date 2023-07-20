INSERT IGNORE INTO `alertparametertype` (`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`, `TypeOfParameter`, `Source`, `ParameterVisibility`,  `ParameterDescription`  ) VALUES
(4792, 153, 'Use Enhanced Price Test', 'Bool', '0', '1', '0', 'FIIND_UseMarketDataFlag', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Use Enhanced Price Test threshold which is a boolean'),
(4793, 153, 'Previous Close Price', 'Double', '', '', '', 'FIIND_PreviousClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.ComputedFactors', 'N', null),
(4794, 153, 'Evaluated Mid Price', 'Double', '', '', '', 'FIIND_EvaluatedMidPrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.ComputedFactors', 'N', null);

UPDATE alerttype t SET t.AlertShortTemplate = 'Insider Trading event warning on FIIND_NoOfExecutions executions with net volume activity of FIIND_NetVolume trades' WHERE t.AlertTypeID = 153;
UPDATE alerttype t SET t.AlertLongTemplate = 'Insider Trading event warning for FIIND_Symbol with FIIND_NoOfExecutions executions within Look Back Period of FIIND_LookBackPeriod where Net volume activity is FIIND_NetVolume trades and Net consideration value is FIIND_NetConsideration. The evaluated mid-price change FIIND_PriceChange. NIP is FIIND_NIP, Novelty is FIIND_Novelty, Relevance is FIIND_Relevance'
WHERE t.AlertTypeID = 153;

-- Model 63 UI Changes
INSERT INTO alertparametertype
(ParameterTypeID, AlertTypeID, ParameterName, ValueDataType, RangeStart, RangeEnd, DefaultValue, SBParameterName, AuditID, OverrideTypeCode, TypeOfParameter, Source, ParameterVisibility, ParameterDescription)
VALUES(4791, 63, 'News Title', 'String', '', '', '', 'IDE_NewsTitle', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL);

