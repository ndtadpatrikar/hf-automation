INSERT IGNORE INTO `alertparametertype` (`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`, `TypeOfParameter`, `Source`, `ParameterVisibility`,  `ParameterDescription`  ) VALUES
(4762,9,'Generate an alert for each account and product combination within the auction period','Bool','0','1','0','MO_EOD_Switch',3,'N','Extract value from tuple','AlertSchema.AlertParameters','Y','Determine whether a single alert should be generated during the auction period'),
(4760,9,'Aggregated Quantity','Double','0','','1','MO_AggregatedQuantity',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','Total aggregated quantity'),
(4761,9,'ADV30','Double','0','','1','MO_ADV30',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADV30 value'),
(4763,9,'ADV Volume Percentage','Percent','0','100','0','MO_ADVVolumePercentage',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADVVolumePercentage'),
(4780,101,'Generate an alert for each account and product combination within the auction period','Bool','0','1','0','OPTMO_EOD_Switch',3,'N','Extract value from tuple','AlertSchema.AlertParameters','Y','Determine whether a single alert should be generated during the auction period'),
(4782,101,'Aggregated Quantity','Double','0','','1','OPTMO_AggregatedQuantity',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','Total aggregated quantity'),
(4783,101,'ADV30','Double','0','','1','OPTMO_ADV30',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADV30 value'),
(4784,101,'ADV Volume Percentage','Percent','0','100','0','OPTMO_ADVVolumePercentage',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADVVolumePercentage'),
(4781,47,'Generate an alert for each account and product combination within the auction period','Bool','0','1','0','FUTMO_EOD_Switch',3,'N','Extract value from tuple','AlertSchema.AlertParameters','Y','Determine whether a single alert should be generated during the auction period'),
(4785,47,'Aggregated Quantity','Double','0','','1','FUTMO_AggregatedQuantity',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','Total aggregated quantity'),
(4786,47,'ADV30','Double','0','','1','FUTMO_ADV30',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADV30 value'),
(4787,47,'ADV Volume Percentage','Percent','0','100','0','FUTMO_ADVVolumePercentage',3,'N','Extract value from tuple','AlertSchema.AlertParameters','N','ADVVolumePercentage');
