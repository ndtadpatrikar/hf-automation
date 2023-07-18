update alertparametertype set ParameterName = 'Quantity Threshold (%)', ParameterDescription = 
'Quantity threshold which is a number between 0 - 100 %' where ParameterTypeID = 2472 and AlertTypeID = 138;
update alertparametertype set ValueDataType = 'Days', RangeEnd = '432000', ParameterDescription = 
'Lookback Period threshold between 0 to 5 days' where ParameterTypeID = 2499 and AlertTypeID = 140;
