-- 1
SELECT DISTINCT SURNAME, NAME, STARTDATE, ENDDATE, TYPE
FROM CONTRACTS
JOIN CLIENTS ON CONTRACTS.CLIENTID=CLIENTS.CLIENTID
JOIN PRODUCTS ON CONTRACTS.CONTRACT_TYPE=PRODUCTS.PRODUCT_NAME
WHERE (SYSDATE BETWEEN STARTDATE AND ENDDATE)
OR (ENDDATE IS NULL AND STARTDATE<=SYSDATE) 
ORDER BY CLIENTS.SURNAME, CLIENTS.NAME;
-- 4423 rows

-- 2
SELECT * FROM (
SELECT DISTINCT ACTOR, COUNT(CASTS.TITLE)
FROM CASTS
INNER JOIN MOVIES ON CASTS.TITLE=MOVIES.MOVIE_TITLE
WHERE MOVIES.COUNTRY='USA'
GROUP BY ACTOR
ORDER BY COUNT(CASTS.TITLE) DESC
) WHERE ROWNUM<=5;
-- Robert De Niro	45
-- Morgan Freeman	36
-- Bruce Willis		35
-- Matt Damon		35
-- Steve Buscemi	33

-- 3 --------------- IN PROGRESS ---------------------------
SELECT LIC_SERIES.CLIENT, CLIENTS.NAME, CLIENTS.SURNAME, LIC_SERIES.TITLE, LIC_SERIES.SEASON
FROM LIC_SERIES
JOIN CLIENTS ON LIC_SERIES.CLIENT=CLIENTS.CLIENTID
JOIN SEASONS ON LIC_SERIES.TITLE=SEASONS.TITLE AND LIC_SERIES.SEASON=SEASONS.SEASON
GROUP BY LIC_SERIES.CLIENT, LIC_SERIES.TITLE, LIC_SERIES.SEASON
HAVING COUNT(EPISODE)=SEASONS.EPISODES;
-- ---------------- IN PROGRESS ------------------
