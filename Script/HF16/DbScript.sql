--Model 53
INSERT IGNORE INTO alertparametertype
(ParameterTypeID, AlertTypeID, ParameterName, ValueDataType, RangeStart, RangeEnd, DefaultValue, SBParameterName, AuditID, OverrideTypeCode, TypeOfParameter, Source, ParameterVisibility, ParameterDescription)
VALUES(4795, 53, 'Use Market Data To Fetch EvaluatedMid-Price', 'Bool', '0', '1', '0', 'FIID_UseMarketDataToFetchEvaluatedMid', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Use Market Data To Fetch EvaluatedMid-Price threshold which is a boolean');

update alerttype set AlertshortTemplate = 'Insider Trading Alert for Master Acccount FIID_MasterAccount on FIID_Ticker with a price spike of FIID_PercentageDifference breaching the threshold.' where AlertTypeID = 53;

update alertparametertype set ParameterName = 'Evaluated Mid Price' where ParameterTypeID = 1601;

update alertparametertype set ParameterName = 'Previous Day Evaluated Mid Price' where ParameterTypeID = 1603;