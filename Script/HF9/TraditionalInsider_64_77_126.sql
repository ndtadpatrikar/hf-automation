INSERT IGNORE INTO `alertparametertype` (`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`, `TypeOfParameter`, `Source`, `ParameterVisibility`,  `ParameterDescription`  ) VALUES
-- Traditional Insider Dealing EQ 64
(4764, 64, 'Account', 'String','','','','TIDE_Account', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4765, 64, 'Net Volume', 'Int','','','','TIDE_NetVolume', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4766, 64, 'Close Price', 'Double','','','','TIDE_ClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4767, 64, 'Previous Close Price', 'Double','','','','TIDE_PreviousClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
-- Traditional Insider Dealing FUT 77
(4768, 77, 'Account', 'String','','','','FUTTIDE_Account', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4769, 77, 'Net Volume', 'Int','','','','FUTTIDE_NetVolume', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4770, 77, 'Close Price', 'Double','','','','FUTTIDE_ClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4771, 77, 'Previous Close Price', 'Double','','','','FUTTIDE_PreviousClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
-- Traditional Insider Dealing OPT 126
(4772, 126, 'Account', 'String','','','','OPTTIDE_Account', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4773, 126, 'Net Volume', 'Int','','','','OPTTIDE_NetVolume', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4774, 126, 'Close Price', 'Double','','','','OPTTIDE_ClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', ''),
(4775, 126, 'Previous Close Price', 'Double','','','','OPTTIDE_PreviousClosePrice', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', '');


-- Traditional Insider Dealing EQ 64
UPDATE alerttype
set
AlertShortTemplate = 'Insider Trading event warning on TIDE_NoOfExecutions Execution(s) preceding a price spike of TIDE_PercentageDifference on Symbol TIDE_Symbol and account TIDE_Account.',
AlertLongTemplate = 'Insider Trading event warning for TIDE_Symbol after a price spike of TIDE_PercentageDifference on account TIDE_Account breaching the Price Spike Threshold of TIDE_PriceSpikeThreshold.The price spike was preceded by TIDE_PrecedingExecutions Execution(s) within Look Back Period of TIDE_LookBackPeriod days with a net volume of TIDE_NetVolume which breached the new volume thresholds of TIDE_VolumeThreshold. The current day closing price is TIDE_ClosePrice and the previous day closing price is TIDE_PreviousClosePrice.'
where AlertTypeID=64;

-- Traditional Insider Dealing FUT 77
UPDATE alerttype
set
AlertShortTemplate = 'Insider Trading event warning on FUTTIDE_NoOfExecutions Execution(s) preceding a price spike of FUTTIDE_PercentageDifference on Symbol FUTTIDE_Symbol and account FUTTIDE_Account.',
AlertLongTemplate = 'Insider Trading event warning for FUTTIDE_Symbol after a price spike of FUTTIDE_PercentageDifference on account FUTTIDE_Account breaching the Price Spike Threshold of FUTTIDE_PriceSpikeThreshold.The price spike was preceded by FUTTIDE_PrecedingExecutions Execution(s) within Look Back Period of FUTTIDE_LookBackPeriod days with a net volume of FUTTIDE_NetVolume which breached the new volume thresholds of FUTTIDE_VolumeThreshold. The current day closing price is FUTTIDE_ClosePrice and the previous day closing price is FUTTIDE_PreviousClosePrice.'
where AlertTypeID=77;

-- Traditional Insider Dealing OPT 126
UPDATE alerttype
set
AlertShortTemplate = 'Insider Trading event warning on OPTTIDE_NoOfExecutions Execution(s) preceding a price spike of OPTTIDE_PercentageDifference on Symbol OPTTIDE_Symbol and account OPTTIDE_Account.',
AlertLongTemplate = 'Insider Trading event warning for OPTTIDE_Symbol after a price spike of OPTTIDE_PercentageDifference on account OPTTIDE_Account breaching the Price Spike Threshold of OPTTIDE_PriceSpikeThreshold.The price spike was preceded by OPTTIDE_PrecedingExecutions Execution(s) within Look Back Period of OPTTIDE_LookBackPeriod days with a net volume of OPTTIDE_NetVolume which breached the new volume thresholds of OPTTIDE_VolumeThreshold. The current day closing price is OPTTIDE_ClosePrice and the previous day closing price is OPTTIDE_PreviousClosePrice.'
where AlertTypeID=126;