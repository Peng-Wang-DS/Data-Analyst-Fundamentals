

SELECT TOP 10
    DateofGoodsIssue,
    DATEADD(WEEK, DATEDIFF(WEEK, 0, DateofGoodsIssue), 0) AS Calendar_Date
FROM dbo.historicaldemandactual

-----------
SELECT 
MAX(DateofGoodsIssue) as max_date

FROM dbo.historicaldemandactual 

-----------
SELECT
TOP 3
    DateofGoodsIssue,
    MAX(DateofGoodsIssue) OVER() as MAX_DATE
FROM dbo.historicaldemandactual
ORDER BY DateofGoodsIssue DESC; 



SELECT top 10
FROM
(
SELECT * 

FROM

(SELECT
    ProductCode,
    DateofGoodsIssue,
    Quantity
From dbo.historicaldemandactual) hd

LEFT JOIN 
(SELECT
    Date,
    DayofMonthNumber,
    MonthCode
From dbo.calendar) cl
ON hd.DateofGoodsIssue = cl.Date


) t

-- WHERE Date IS NOT NULL;