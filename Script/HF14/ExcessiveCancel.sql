-- Update for excessive cancel FUT-OPT-EQ

update alerttype
set AlertShortTemplate='EC_CancelOrderCount orders were cancelled with cancelled to valid order ratio of EC_CancelPercent % breaching the minimum number of orders threshold of EC_MinimumOrders and cancel threshold of EC_PercentageCancelled.',
AlertLongTemplate ='Excessive Cancels alert for Account:EC_Account for having cancelled to valid order ratio of EC_CancelPercent  which breaches the defined cancel threshold of EC_PercentageCancelled %. Also, the total number of orders is EC_TotalOrderCount which breached the minimum total number of orders threshold of EC_MinimumOrders orders.'
where AlertTypeID=18;

update alerttype
set AlertShortTemplate='OPTEC_CancelOrderCount orders were cancelled with cancelled to valid order ratio of OPTEC_CancelPercent % breaching the minimum number of orders threshold of OPTEC_MinimumOrders and cancel threshold of OPTEC_PercentageCancelled.',
AlertLongTemplate ='Excessive Cancels alert for Account:OPTEC_Account for having cancelled to valid order ratio of OPTEC_CancelPercent  which breaches the defined cancel threshold of OPTEC_PercentageCancelled. Also, the total number of orders is OPTEC_TotalOrderCount which breached the minimum total number of orders threshold of OPTEC_MinimumOrders orders.'
where AlertTypeID=112;

update alerttype
set AlertShortTemplate='FUTEC_CancelOrderCount orders were cancelled with cancelled to valid order ratio of FUTEC_CancelPercent % breaching the minimum number of orders threshold of FUTEC_MinimumOrders and cancel threshold of FUTEC_PercentageCancelled.',
AlertLongTemplate ='Excessive Cancels alert for Account:FUTEC_Account for having cancelled to valid order ratio of FUTEC_CancelPercent  which breaches the defined cancel threshold of FUTEC_PercentageCancelled. Also, the total number of orders is FUTEC_TotalOrderCount which breached the minimum total number of orders threshold of FUTEC_MinimumOrders orders.'
where AlertTypeID=88;


-- Excessive Cancel EQ-FUT-OPT

INSERT IGNORE INTO `alertparametertype` (`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`, `TypeOfParameter`, `Source`, `ParameterVisibility`,  `ParameterDescription`  ) VALUES

(4820, 18, 'Total order count new calculation', 'Bool','0','1','0','EC_TotalOrderCountNewCalculation', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'Y', 'Total order count new calculation threshold which is a boolean'),
(4821, 88, 'Total order count new calculation', 'Bool','0','1','0','FUTEC_TotalOrderCountNewCalculation', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'Y', 'Total order count new calculation threshold which is a boolean'),
(4822, 112, 'Total order count new calculation', 'Bool','0','1','0','OPTEC_TotalOrderCountNewCalculation', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'Y', 'Total order count new calculation threshold which is a boolean');


update alertparametertype set ParameterName = 'Number Of Qualified Orders'   where ParameterTypeID = 212; 
update alertparametertype set SBParameterName = 'EC_QualifiedOrderCount' where ParameterTypeID = 212; 
update alertparametertype set ParameterName = 'Number Of Qualified Orders' where ParameterTypeID = 1522;
update alertparametertype set SBParameterName = 'FUTEC_QualifiedOrderCount'  where ParameterTypeID = 1522; 
update alertparametertype set ParameterName = 'Number Of Qualified Orders' where ParameterTypeID = 2130; 
update alertparametertype set  SBParameterName = 'OPTEC_QualifiedOrderCount'  where ParameterTypeID = 2130; 


