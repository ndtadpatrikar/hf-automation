DROP procedure IF exists `InsiderTradingProcUnderlying`;
DELIMITER $$
CREATE PROCEDURE `InsiderTradingProcUnderlying`(IN NewsID varchar(130), IN StartTime Datetime, IN StopTime Datetime, IN Security_ISIN char(30))
BEGIN

    Create Temporary Table TempInsiderTradingExecs (
                                                       ExecID            char(70),
                                                       DisplayExecID     char(255),
                                                       ClOrdID           char(70),
                                                       MsgType           char(1),
                                                       Side              char(30),
                                                       TradeQuantity     double,
                                                       Symbol            char(45),
                                                       InstrumentID      int(20),
                                                       TradePrice        double,
                                                       Account           char(100),
                                                       TradeTimestamp    Datetime,
                                                       TraderID          char(100),
                                                       SystemID          char(30),
                                                       ISIN              char(30),
                                                       UnderlyingISIN    char(30),
                                                       SecurityID        char(30),
                                                       IDSource          char(1),
                                                       SecurityExchange  char(30),
                                                       NewsID            char(130),
                                                       LastExecID        char(70),
                                                       SecurityType      varchar(30),
                                                       RootOrdID         char(70),
                                                       OrdExec           char(1),
                                                       Currency          char(10)
    );

    Create Temporary Table TempAccount (
        Account           char(100)
    );


    Insert into TempInsiderTradingExecs(
        Select
            a.ExecID,
            a.DisplayExecID,
            ClOrdID,
            MsgType,
            Side,
            TradeQuantity,
            a.Symbol,
            a.InstrumentID,
            TradePrice,
            Account,
            TradeTimestamp,
            TraderID,
            SystemID,
            a.ISIN,
            a.UnderlyingISIN,
            SecurityID,
            IDSource,
            SecurityExchange,
            NewsID,
            Case When YExecs.LastExec is null Then
                     'N'
                 Else
                     'Y'
                End AS LastExecID,
            SecurityType,
            null as RootOrdID,
            'E' as OrdExec,
            Currency
        From
            executions a
                left join (
                Select
                    SUBSTRING(
                            MAX(
                                    CONCAT(
                                            ee.TradeTimestamp, '|' , ee.DisplayExecID
                                        )
                                ), 1+LOCATE(
                            '|', MAX(
                                    CONCAT(
                                            ee.TradeTimestamp, '|', ee.DisplayExecID
                                        )
                                )
                        )
                        ) as DisplayExecID,
                    'Y' as LastExec
                From
                    executions ee
                Where
                        ee.UnderlyingISIN = Security_ISIN
                  And ee.TradeTimestamp Between Date(StartTime) And StopTime
                Group by
                    ee.ACCOUNT
            ) as YExecs
                          on
                                  a.DisplayExecID = YExecs.DisplayExecID
        Where
                a.UnderlyingISIN = Security_ISIN
          And a.TradeTimestamp Between Date(StartTime) And StopTime
    );


    Insert into TempAccount(Select distinct Account From TempInsiderTradingExecs);


    Insert into TempInsiderTradingExecs(
        Select
            a.ClOrdID As ExecID,
            a.DisplayOrderID As DisplayExecID,
            ClOrdID,
            MsgType,
            Side,
            Case When MsgType = 'F' Then
                         a.Quantity * -1
                 Else
                     a.Quantity
                End As TradeQuantity,
            a.Symbol,
            a.InstrumentID,
            a.Price As TradePrice,
            Account,
            OrderTimestamp As TradeTimestamp,
            TraderID,
            SystemID,
            a.ISIN,
            a.UnderlyingISIN,
            SecurityID,
            IDSource,
            MIC as SecurityExchange,
            NewsID,
            Case When YExecs.LastExec is null Then
                     'N'
                 Else
                     'Y'
                End AS LastExecID,
            SecurityType,
            OrigClOrdID, 'O' As OrdExec,
            Currency
        From
            orders a
                left join (
                Select
                    SUBSTRING(
                            MAX(
                                    CONCAT(
                                            o2.OrderTimestamp, '|' ,o2.DisplayOrderID
                                        )
                                ), 1+LOCATE(
                            '|',MAX(
                                    CONCAT(
                                            o2.OrderTimestamp, '|' ,o2.DisplayOrderID
                                        )
                                )
                        )
                        ) as DisplayExecID,
                    'Y' as LastExec
                From
                    orders o2
                Where
                        o2.UnderlyingISIN = Security_ISIN
                  And o2.OrderTimestamp Between Date(StartTime) And StopTime
                Group By
                    o2.Account
            )  as YExecs
                          on
                                  a.DisplayOrderID=YExecs.DisplayExecID
                left join (
                Select
                    MAX(
                            CONCAT(
                                    o3.OrderTimestamp, '|', o3.RootOrdID, '|', Case When o3.MsgType = 'F' Then 'F' Else 'O' End)) As RootOrdIDConcat
                From
                    orders o3
                Where
                        o3.ISIN = Security_ISIN
                  And o3.OrderTimestamp Between Date(StartTime) And StopTime
                Group By
                    CONCAT(
                            o3.RootOrdID, '|', Case When o3.MsgType = 'F' Then 'F' Else 'O' End
                        )
            ) As ro
                          on
                                  CONCAT(
                                          a.OrderTimestamp, '|', a.RootOrdID, '|', Case When a.MsgType = 'F' Then 'F' Else 'O' End
                                      ) = ro.RootOrdIDConcat
        Where
                a.UnderlyingISIN IN (Security_ISIN)
          And a.OrdType <> 1
          And a.OrderTimestamp Between Date(StartTime) And StopTime
          And CONCAT(
                      a.OrderTimestamp, '|', a.RootOrdID, '|', Case When a.MsgType = 'F' Then 'F' Else 'O' End
                  ) = ro.RootOrdIDConcat
          And Not Exists (Select te.Account As ExecAccount From TempAccount te Where a.Account = te.Account)
    );

    Select
        ExecID,
        ClOrdID,
        MsgType,
        Side,
        TradeQuantity,
        Symbol,
        InstrumentID,
        TradePrice,
        Account,
        TradeTimestamp,
        TraderID,
        SystemID,
        ISIN,
        UnderlyingISIN,
        SecurityID,
        IDSource,
        SecurityExchange,
        NewsID,
        LastExecID,
        SecurityType,
        RootOrdID,
        OrdExec,
        Currency
    From
        TempInsiderTradingExecs
    Order By
        Account,
        TradeTimestamp,
        DisplayExecID
    ;

    Drop table TempInsiderTradingExecs;
    Drop table TempAccount;

End$$
DELIMITER ;




DROP procedure IF exists `InsiderTradingProc`;
DELIMITER $$
CREATE PROCEDURE `InsiderTradingProc`(IN NewsID varchar(130), IN StartTime Datetime, IN StopTime Datetime, IN Security_ISIN char(30))
  BEGIN

    Create Temporary Table TempInsiderTradingExecs (
      ExecID            char(70),
      DisplayExecID     char(255),
      ClOrdID           char(70),
      MsgType           char(1),
      Side              char(30),
      TradeQuantity     double,
      Symbol            char(45),
      InstrumentID      int(20),
      TradePrice        double,
      Account           char(100),
      TradeTimestamp    Datetime,
      TraderID          char(100),
      SystemID          char(30),
      ISIN              char(30),
      UnderlyingISIN    char(30),
      SecurityID        char(30),
      IDSource          char(1),
      SecurityExchange  char(30),
      NewsID            char(130),
      LastExecID        char(70),
      SecurityType      varchar(30),
      RootOrdID         char(70),
      OrdExec           char(1),
      Currency          char(10)
    );

    Create Temporary Table TempAccount (
      Account           char(100)
    );


    Insert into TempInsiderTradingExecs(
      Select
        a.ExecID,
        a.DisplayExecID,
        ClOrdID,
        MsgType,
        Side,
        TradeQuantity,
        a.Symbol,
        a.InstrumentID,
        TradePrice,
        Account,
        TradeTimestamp,
        TraderID,
        SystemID,
        a.ISIN,
        a.UnderlyingISIN,
        SecurityID,
        IDSource,
        SecurityExchange,
        NewsID,
        Case When YExecs.LastExec is null Then
          'N'
        Else
          'Y'
        End AS LastExecID,
        SecurityType,
        null as RootOrdID,
        'E' as OrdExec,
        Currency
      From
        executions a
        left join (
                    Select
                      SUBSTRING(
                          MAX(
                              CONCAT(
                                  ee.TradeTimestamp, '|' , ee.DisplayExecID
                              )
                          ), 1+LOCATE(
                              '|', MAX(
                                  CONCAT(
                                      ee.TradeTimestamp, '|', ee.DisplayExecID
                                  )
                              )
                         )
                      ) as DisplayExecID,
                      'Y' as LastExec
                    From
                      executions ee
                    Where
                      ee.ISIN = Security_ISIN
                      And ee.TradeTimestamp Between Date(StartTime) And StopTime
                    Group by
                      ee.ACCOUNT
                 ) as YExecs
          on
            a.DisplayExecID = YExecs.DisplayExecID
      Where
        a.ISIN = Security_ISIN
        And a.TradeTimestamp Between Date(StartTime) And StopTime
    );


    Insert into TempAccount(Select distinct Account From TempInsiderTradingExecs);


    Insert into TempInsiderTradingExecs(
      Select
                                a.ClOrdID As ExecID,
                                a.DisplayOrderID As DisplayExecID,
        ClOrdID,
        MsgType,
        Side,
                                Case When MsgType = 'F' Then
                                a.Quantity * -1
                                Else
                                a.Quantity
                                End As TradeQuantity,
        a.Symbol,
        a.InstrumentID,
                                a.Price As TradePrice,
        Account,
                                OrderTimestamp As TradeTimestamp,
        TraderID,
        SystemID,
        a.ISIN,
        a.UnderlyingISIN,
        SecurityID,
        IDSource,
                                MIC as SecurityExchange,
        NewsID,
                                Case When YExecs.LastExec is null Then
                                'N'
                                Else
                                'Y'
                                End AS LastExecID,
        SecurityType,
        OrigClOrdID, 'O' As OrdExec,
        Currency
      From
        orders a
        left join (
                    Select
                      SUBSTRING(
                          MAX(
                             CONCAT(
                                  o2.OrderTimestamp, '|' ,o2.DisplayOrderID
                              )
                          ), 1+LOCATE(
                              '|',MAX(
                                  CONCAT(
                                      o2.OrderTimestamp, '|' ,o2.DisplayOrderID
                                  )
                              )
                          )
                      ) as DisplayExecID,
                      'Y' as LastExec
                    From
                      orders o2
                    Where
                      o2.ISIN = Security_ISIN
                      And o2.OrderTimestamp Between Date(StartTime) And StopTime
                    Group By
                      o2.Account
                  )  as YExecs
          on
            a.DisplayOrderID=YExecs.DisplayExecID
        left join (
                    Select
                      MAX(
                          CONCAT(
                              o3.OrderTimestamp, '|', o3.RootOrdID, '|', Case When o3.MsgType = 'F' Then 'F' Else 'O' End)) As RootOrdIDConcat
                    From
                      orders o3
                    Where
                      o3.ISIN = Security_ISIN
                      And o3.OrderTimestamp Between Date(StartTime) And StopTime
                    Group By
                      CONCAT(
                          o3.RootOrdID, '|', Case When o3.MsgType = 'F' Then 'F' Else 'O' End
                      )
                  ) As ro
          on
            CONCAT(
                a.OrderTimestamp, '|', a.RootOrdID, '|', Case When a.MsgType = 'F' Then 'F' Else 'O' End
            ) = ro.RootOrdIDConcat
      Where
        a.ISIN IN (Security_ISIN)
        And a.OrdType <> 1
        And a.OrderTimestamp Between Date(StartTime) And StopTime
        And CONCAT(
                a.OrderTimestamp, '|', a.RootOrdID, '|', Case When a.MsgType = 'F' Then 'F' Else 'O' End
            ) = ro.RootOrdIDConcat
        And Not Exists (Select te.Account As ExecAccount From TempAccount te Where a.Account = te.Account)
    );

    Select
      ExecID,
      ClOrdID,
      MsgType,
      Side,
      TradeQuantity,
      Symbol,
      InstrumentID,
      TradePrice,
      Account,
      TradeTimestamp,
      TraderID,
      SystemID,
      ISIN,
      UnderlyingISIN,
      SecurityID,
      IDSource,
      SecurityExchange,
      NewsID,
      LastExecID,
      SecurityType,
      RootOrdID,
      OrdExec,
      Currency
    From
      TempInsiderTradingExecs
    Order By
      Account,
      TradeTimestamp,
      DisplayExecID
    ;

    Drop table TempInsiderTradingExecs;
    Drop table TempAccount;

  End$$
DELIMITER ;