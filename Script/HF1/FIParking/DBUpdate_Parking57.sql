DELIMITER $$
DROP procedure IF EXISTS `FIParkingForAggregationNo`$$
CREATE PROCEDURE `FIParkingForAggregationNo`(IN in_tradeDate datetime,
                                                       IN in_side varchar(5),
                                                       IN in_securityType varchar(20),
                                                       IN in_period int)
BEGIN
    SET group_concat_max_len = 10000;
    select TradeId                                               'TradeId',
           MasterAccount                                         'Account',
           SecurityID                                            'SecurityID',
           Ticker                                                'InstrumentID',
		   Book													 'Book',
		   Issuer												 'Issuer',
           SecurityID                                            'ISIN',
           Ticker                                                'Symbol',
           SecurityType                                          'SecurityType',
           VenueID                                               'SecurityExchange',
           TradeTimestamp                                        'TradeTimeStamp',
           Currency                                              'Currency',
           PrevTradeId                                           'ClOrdIDs',
           TradeQuantity                                         'Value',
           TradeQuantity                                         'Volume',
           Side                                          		 'Side',
           ClientData1 											 'ClientData1',
           ClientData2                                           'ClientData2',
           ClientData3                                           'ClientData3'
    from trades ex1
    where Date(TradeTimestamp) > DATE_SUB(in_tradeDate, INTERVAL in_period SECOND)
      and FIND_IN_SET(Side, in_side)
      and FIND_IN_SET(SecurityType, in_securityType)
    and MsgType = 'D';
END $$
DELIMITER ;



INSERT IGNORE INTO `alertparametertype` (`ParameterTypeID`,`AlertTypeID`,`ParameterName`, `ValueDataType`, `RangeStart`, `RangeEnd`, `DefaultValue`, `SBParameterName`, `AuditID`, `OverrideTypeCode`, `TypeOfParameter`, `Source`, `ParameterVisibility`,  `ParameterDescription`  ) VALUES
(4659, 57, 'Parking Ratio Threshold', 'Int', '0', '100', '99', 'FIP_Parking_RatioThreshold', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Parking Ratio threshold which is a number between 0 - 100'),
(4660, 57, 'Parking Ratio', 'Int', '0', '100', '', 'FIP_ParkingRatio', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4661, 57, 'Parking Side', 'String', '', '', '', 'FIP_UISide', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4662, 57, 'Qualified Trade', 'Int', '', '', '', 'FIP_QualifiedHPETrade', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4663, 57, 'Side Switch', 'Int', '1', '3', '2', 'FIP_SideSwitch', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Side Switch threshold which is a number between 1 - 3'),
(4664, 57, 'Aggregated Trade Quantity', 'Bool', '0', '1', '0', 'FIP_AggregatedTradeQuantity', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'Aggregated Trade Quantity threshold which is a boolean'),
(4665, 57, 'Qualified Opposite Side Trade', 'Int', '', '', '', 'FIP_QualifiedHPSTrade', 3, 'N', 'Extract value from tuple', 'AlertSchema.AlertFactors', 'N', NULL),
(4666, 57, 'UseLegacy', 'Bool', '0', '1', '0', 'FIP_UseLegacy', 3, 'C', 'Extract value from tuple', 'AlertSchema.AlertParameters', 'Y', 'UseLegacy threshold which is a boolean');






UPDATE alerttype 
set 
AlertShortTemplate = 'Parking alert on ticker FIP_Ticker for Master Account FIP_MasterAccount. The parking ratio percentage change is within FIP_ParkingRatio%.',
AlertLongTemplate = 'Parking alert on ticker FIP_Ticker for Master Account FIP_MasterAccount. The traded quantity on FIP_UISide side was found to be FIP_QualifiedHPETrade which breached the quantity threshold set as FIP_QuantityThreshold. The parking ratio percentage change is within FIP_ParkingRatio% which is less than or equal to parking ratio threshold value set as FIP_Parking_RatioThreshold%.'
where AlertTypeID=57;
