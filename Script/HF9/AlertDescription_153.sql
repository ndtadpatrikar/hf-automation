-- FI News Based Insider Trading  153
UPDATE alerttype
SET
    AlertLongTemplate='Insider Trading event warning for FIIND_Symbol with FIIND_NoOfExecutions executions within Look Back Period of FIIND_LookBackPeriod. Net volume activity is FIIND_NetVolume , Net consideration: FIIND_NetConsideration'
WHERE AlertTypeID=153;