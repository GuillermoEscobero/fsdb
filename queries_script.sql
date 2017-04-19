-------------------------------------------------------------------------------
-- queries_script.sql
-- 		Guillermo Escobero (100346060)
-- 		Raul Olmedo Checa (100346073)
-------------------------------------------------------------------------------

-- a) Alphabetical list (by surname, name) of all clients with active contract
-- in the date when the query is run, along with start and end dates and type
-- (PPC/PPV) of the contract.
SELECT surname, name, startdate, enddate, type
FROM clients
NATURAL JOIN contracts
JOIN products ON contract_type=product_name
WHERE (SYSDATE BETWEEN startdate AND enddate)
OR (enddate IS NULL AND startdate<=SYSDATE)
ORDER BY lower(surname), lower(name);
-- 4323 rows (at 17/4/2017)


-- b) Top 5 stars involved in more movies from USA.
SELECT * FROM (
SELECT actor, COUNT(title)
FROM casts
JOIN movies ON title=movie_title
WHERE country='USA'
GROUP BY actor
ORDER BY COUNT(title) DESC
) WHERE ROWNUM<=5;
-- ACTOR						   COUNT(TITLE)
-- --------------------------------
-- Robert De Niro						45
-- Morgan Freeman						36
-- Bruce Willis						  35
-- Matt Damon						    35
-- Steve Buscemi						33

-- c) Clients who have bought license for a complete season of any TVseries
-- (include the title and season).
SELECT client, title, season
FROM lic_series
NATURAL JOIN seasons
GROUP BY client, title, season, episodes
HAVING COUNT(episode)=episodes;
-- 2104 rows


-- d) Top-Star: actor/actress who had got more taps (summing up all the taps of
-- his/her movies) for each month (should retrieve a row for each month since
-- the database is on duty).
SELECT A.month, actor, top
FROM (
		SELECT MAX(counter) as top, month
		FROM (
			SELECT TO_CHAR(view_datetime, 'MON-YYYY') AS month, actor, COUNT(title) AS counter
			FROM taps_movies
			NATURAL JOIN casts
			GROUP BY TO_CHAR(view_datetime, 'MON-YYYY'), actor
		)
		GROUP BY month
) A
JOIN
(
	SELECT TO_CHAR(view_datetime, 'MON-YYYY') AS month, actor, COUNT(title) AS counter
	FROM taps_movies
	NATURAL JOIN casts
	GROUP BY TO_CHAR(view_datetime, 'MON-YYYY'), actor
) B
ON top=counter AND A.month=B.month
ORDER BY TO_DATE(month, 'MON-YYYY');
-- MONTH    ACTOR                     TOP
---------- ------------------ -----------
-- ENE-2016 Robert De Niro            188
-- FEB-2016 Robert De Niro            177
-- MAR-2016 Robert De Niro            194
-- ABR-2016 Robert De Niro            202
-- MAY-2016 Robert De Niro            200
-- JUN-2016 Robert De Niro            205
-- JUL-2016 Robert De Niro            197
-- AGO-2016 Robert De Niro            206
-- SEP-2016 Robert De Niro            228
-- OCT-2016 Robert De Niro            228
-- NOV-2016 Robert De Niro            222
-- DIC-2016 Morgan Freeman            230
