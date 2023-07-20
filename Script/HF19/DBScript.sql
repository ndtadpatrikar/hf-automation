-- Update for excessive cancel EQ

update alerttype
set AlertShortTemplate='EC_CancelOrderCount orders were cancelled with cancelled to valid order ratio of EC_CancelPercent % breaching the minimum number of orders threshold of EC_MinimumOrders and cancel threshold of EC_PercentageCancelled.',
AlertLongTemplate ='Excessive Cancels alert for Account:EC_Account for having cancelled to valid order ratio of EC_CancelPercent  which breaches the defined cancel threshold of EC_PercentageCancelled. Also, the total number of orders is EC_TotalOrderCount which breached the minimum total number of orders threshold of EC_MinimumOrders orders.'
where AlertTypeID=18;


