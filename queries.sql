-------------------------------------------------------------------------------
-- queries.sql
-- Queries data for analysis
-- Raul Olmedo & Guillermo Escobero
-- UC3M - Group 89
-------------------------------------------------------------------------------

SET LINESIZE 256;
SET TRIMSPOOL ON;
SET TRIMOUT ON;
SET WRAP OFF;
SET TERMOUT OFF;
SET PAGESIZE 0;
set serveroutput on;
set autotrace on;
set timing on;

--Para mostrar los indexes del usuario
select * from user_indexes;


--Query 1
SELECT SURNAME, SEC_SURNAME, NAME, CONTRACT_TYPE, STARTDATE,ENDDATE,TYPE
FROM
 (SELECT CLIENTID, CONTRACT_TYPE, STARTDATE,ENDDATE FROM CONTRACTS WHERE  ENDDATE>SYSDATE OR ENDDATE IS NULL) A
  JOIN
 (SELECT TYPE, PRODUCT_NAME FROM PRODUCTS) B ON (A.CONTRACT_TYPE=B.PRODUCT_NAME)
  JOIN
 CLIENTS C ON (A.CLIENTID=C.CLIENTID)
ORDER BY SURNAME, SEC_SURNAME, NAME;

CREATE INDEX contracts_enddate_index ON CONTRACTS (ENDDATE);
CREATE INDEX products_type_and_name_index ON PRODUCTS (TYPE, PRODUCT_NAME);

/*
SIN CLUSTERS
------------------------------------------------------------------------------------------
| Id  | Operation	           | Name	     | Rows  | Bytes |TempSpc| Cost (%CPU)| Time	   |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |		       |  4094 |   939K|	     |   305   (1)| 00:00:04 |
|   1 |  SORT ORDER BY	     |		       |  4094 |   939K|  1032K|   305   (1)| 00:00:04 |
|*  2 |   HASH JOIN	         |		       |  4094 |   939K|	     |    95   (3)| 00:00:02 |
|*  3 |    HASH JOIN	       |		       |  4094 |   279K|	     |    72   (2)| 00:00:01 |
|   4 |     TABLE ACCESS FULL| PRODUCTS  |     8 |   128 |	     |     3   (0)| 00:00:01 |
|*  5 |     TABLE ACCESS FULL| CONTRACTS |  4094 |   215K|	     |    68   (0)| 00:00:01 |
|   6 |    TABLE ACCESS FULL | CLIENTS	 |  4666 |   751K|	     |    22   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CLIENTID"="C"."CLIENTID")
   3 - access("CONTRACT_TYPE"="PRODUCT_NAME")
   5 - filter("ENDDATE" IS NULL OR "ENDDATE">SYSDATE@!)

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
 1454  recursive calls
	  0  db block gets
	738  consistent gets
	253  physical reads
	  0  redo size
218803  bytes sent via SQL*Net to client
 3440  bytes received via SQL*Net from client
	283  SQL*Net roundtrips to/from client
	 19  sorts (memory)
	  0  sorts (disk)
 4224  rows processed

*/

/*
CON CLUSTER E INDEX
----------------------------------------------------------------------------------------------------------------
| Id  | Operation		               | Name			                    | Rows  | Bytes |TempSpc| Cost (%CPU)| Time    |
----------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	         |			                        |  4234 |   917K|       |  1709	 (1)| 00:00:21 |
|   1 |  SORT ORDER BY		         |			                        |  4234 |   917K|   976K|  1709	 (1)| 00:00:21 |
|*  2 |   HASH JOIN		             |			                        |  4234 |   917K|       |  1501	 (1)| 00:00:19 |
|   3 |    INDEX FULL SCAN	       | PRODUCTS_TYPE_AND_NAME_INDEX |     8 |   128 |       |     1	 (0)| 00:00:01 |
|   4 |    NESTED LOOPS 	         |			                        |  4234 |   851K|       |  1499	 (1)| 00:00:18 |
|   5 |     TABLE ACCESS FULL	     | CLIENTS		                  |  4074 |   656K|       |  1367	 (1)| 00:00:17 |
|*  6 |     TABLE ACCESS CLUSTER   | CONTRACTS		                |     1 |    41 |       |     1	 (0)| 00:00:01 |
|*  7 |      INDEX UNIQUE SCAN	   | INDEX_CLIENT		              |     1 |       |       |     0	 (0)| 00:00:01 |
----------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access("CONTRACT_TYPE"="PRODUCT_NAME")
   6 - filter("ENDDATE" IS NULL OR "ENDDATE">SYSDATE@!)
   7 - access("CLIENTID"="C"."CLIENTID")

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
	  0  recursive calls
	  0  db block gets
15043  consistent gets
 1834  physical reads
	  0  redo size
218808  bytes sent via SQL*Net to client
 3440  bytes received via SQL*Net from client
	283  SQL*Net roundtrips to/from client
	  1  sorts (memory)
	  0  sorts (disk)
 4224  rows processed

*/




-- QUERY 2
SELECT *
FROM (SELECT B.ACTOR, COUNT('X') USA_MOVIES
         FROM (SELECT MOVIE_TITLE FROM MOVIES WHERE COUNTRY='USA') A
              JOIN CASTS B ON (A.MOVIE_TITLE=B.TITLE)
         GROUP BY B.ACTOR
         ORDER BY USA_MOVIES DESC)
WHERE ROWNUM<6;

CREATE INDEX movies_country_index ON MOVIES (COUNTRY);
CREATE INDEX casts_actor_index ON CASTS (ACTOR);--no hace na

/*
STOCK
----------------------------------------------------------------------------------
| Id  | Operation		            | Name	 | Rows  | Bytes | Cost (%CPU)| Time	   |
----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	      |	       |     5 |   200 |    58   (7)| 00:00:01 |
|*  1 |  COUNT STOPKEY		      |	       |	     |	     |	          | 	       |
|   2 |   VIEW			            |	       | 11342 |   443K|    58   (7)| 00:00:01 |
|*  3 |    SORT ORDER BY STOPKEY|	       | 11342 |  1606K|    58   (7)| 00:00:01 |
|   4 |     HASH GROUP BY	      |	       | 11342 |  1606K|    58   (7)| 00:00:01 |
|*  5 |      HASH JOIN		      |	       | 11342 |  1606K|    55   (2)| 00:00:01 |
|*  6 |       TABLE ACCESS FULL | MOVIES |  3567 |   229K|    32   (0)| 00:00:01 |
|   7 |       TABLE ACCESS FULL | CASTS  | 15612 |  1204K|    22   (0)| 00:00:01 |
----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<6)
   3 - filter(ROWNUM<6)
   5 - access("MOVIE_TITLE"="B"."TITLE")
   6 - filter("COUNTRY"='USA')

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
	  0  recursive calls
	  0  db block gets
	190  consistent gets
	  0  physical reads
	  0  redo size
	503  bytes sent via SQL*Net to client
	350  bytes received via SQL*Net from client
	  2  SQL*Net roundtrips to/from client
	  1  sorts (memory)
	  0  sorts (disk)
	  5  rows processed
*/

/* --TODO esto no esta bien...
CON CLUSTERS E INDEXES
---------------------------------------------------------------------------------------------------------
| Id  | Operation			                   | Name 		            | Rows	| Bytes | Cost (%CPU)| Time	    |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT		             |			                |     5 |   200 |    48   (9)| 00:00:01 |
|*  1 |  COUNT STOPKEY			             |			                |	      |	      |	           |		      |
|   2 |   VIEW				                   |			                | 12698 |   496K|    48   (9)| 00:00:01 |
|*  3 |    SORT ORDER BY STOPKEY	       |			                | 12698 |  1798K|    48   (9)| 00:00:01 |
|   4 |     HASH GROUP BY		             |			                | 12698 |  1798K|    48   (9)| 00:00:01 |
|*  5 |      HASH JOIN			             |			                | 12698 |  1798K|    45   (3)| 00:00:01 |
|   6 |       TABLE ACCESS BY INDEX ROWID| MOVIES		            |  4074 |   262K|    21   (0)| 00:00:01 |
|*  7 |        INDEX RANGE SCAN 	       | MOVIES_COUNTRY_INDEX |    23 |	      |     1   (0)| 00:00:01 |
|   8 |       INDEX FAST FULL SCAN	     | PK_CASTS		          | 12700 |   979K|    23   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(ROWNUM<6)
   3 - filter(ROWNUM<6)
   5 - access("MOVIE_TITLE"="B"."TITLE")
   7 - access("COUNTRY"='USA')

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
	 14  recursive calls
	  0  db block gets
 4126  consistent gets
	156  physical reads
	  0  redo size
	503  bytes sent via SQL*Net to client
	349  bytes received via SQL*Net from client
	  2  SQL*Net roundtrips to/from client
	  1  sorts (memory)
	  0  sorts (disk)
	  5  rows processed
*/

-- QUERY 3
SELECT A.CLIENT, A.TITLE
   FROM (SELECT CLIENT,TITLE,COUNT('X') N_EPISODIOS FROM LIC_SERIES GROUP BY CLIENT,TITLE) A
        JOIN (SELECT TITLE, SUM(EPISODES) TOTAL_EP FROM SEASONS GROUP BY TITLE) B
        ON (A.TITLE=B.TITLE AND A.N_EPISODIOS=B.TOTAL_EP);

CREATE INDEX seasons_title_index ON SEASONS (TITLE);


/*
STOCK
---------------------------------------------------------------------------------
| Id  | Operation	           | Name	      | Rows  | Bytes | Cost (%CPU)| Time	    |
-----------------------------------------------------------------------------------
|   0 | SELECT STATEMENT     |		        |  1786 |   242K|   361   (5)| 00:00:05 |
|*  1 |  HASH JOIN	         |		        |  1786 |   242K|   361   (5)| 00:00:05 |
|   2 |   VIEW		           |		        |   750 | 48750 |	    4  (25)| 00:00:01 |
|   3 |    HASH GROUP BY     |		        |   750 | 48750 |	    4  (25)| 00:00:01 |
|   4 |     TABLE ACCESS FULL| SEASONS	  |   750 | 48750 |	    3   (0)| 00:00:01 |
|   5 |   VIEW		           |		        |   178K|    12M|   355   (4)| 00:00:05 |
|   6 |    HASH GROUP BY     |		        |   178K|    10M|   355   (4)| 00:00:05 |
|   7 |     TABLE ACCESS FULL| LIC_SERIES |   178K|    10M|   344   (1)| 00:00:05 |
-----------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - access("A"."TITLE"="B"."TITLE" AND "A"."N_EPISODIOS"="B"."TOTAL_EP")

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
	 25  recursive calls
	  0  db block gets
 1518  consistent gets
	 25  physical reads
	  0  redo size
	544  bytes sent via SQL*Net to client
	350  bytes received via SQL*Net from client
	  2  SQL*Net roundtrips to/from client
	  0  sorts (memory)
	  0  sorts (disk)
	  5  rows processed
*/



-- QUERY 4
WITH A AS (SELECT TITLE, TO_CHAR(VIEW_DATETIME,'YYYY-MM') eachmonth FROM TAPS_MOVIES),
     B AS (SELECT CASTS.ACTOR, A.eachmonth, COUNT('X') totaltaps
              FROM A JOIN CASTS ON (A.TITLE=CASTS.TITLE)
              GROUP BY CASTS.ACTOR, A.eachmonth),
     C AS (SELECT eachmonth,MAX(totaltaps) maxtaps FROM B GROUP BY eachmonth)
SELECT C.eachmonth month, B.ACTOR, B.totaltaps
   FROM C JOIN B ON (B.eachmonth=C.eachmonth AND B.totaltaps=C.maxtaps)
   ORDER BY C.eachmonth;

/*
STOCK
------------------------------------------------------------------------------------------------------------------
| Id  | Operation		               | Name			                   | Rows  | Bytes |TempSpc| Cost (%CPU)| Time	   |
------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT	         |				                     |     1 |    63 |	     | 10425   (2)| 00:02:06 |
|   1 |  TEMP TABLE TRANSFORMATION |				                     |	     |	     |	     |	          |       	 |
|   2 |   LOAD AS SELECT	         | SYS_TEMP_0FD9D7134_10C61A5C |	     |	     |	     |	          | 	       |
|   3 |    HASH GROUP BY	         |				                     |   854K|   114M|	     |  1530   (5)| 00:00:19 |
|*  4 |     HASH JOIN		           |				                     |   854K|   114M|  1392K|  1475   (1)| 00:00:18 |
|   5 |      TABLE ACCESS FULL	   | CASTS			                 | 15612 |  1204K|	     |    22   (0)| 00:00:01 |
|   6 |      TABLE ACCESS FULL	   | TAPS_MOVIES		             |   268K|    15M|	     |   448   (2)| 00:00:06 |
|   7 |   SORT ORDER BY 	         |				                     |     1 |    63 |	     |  8895   (2)| 00:01:47 |
|*  8 |    HASH JOIN		           |				                     |     1 |    63 |	     |  8894   (2)| 00:01:47 |
|   9 |     VIEW		               |				                     |     1 |    18 |	     |  4471   (2)| 00:00:54 |
|  10 |      HASH GROUP BY	       |				                     |     1 |    18 |	     |  4471   (2)| 00:00:54 |
|  11 |       VIEW		             |				                     |   854K|    14M|	     |  4417   (1)| 00:00:53 |
|  12 |        TABLE ACCESS FULL   | SYS_TEMP_0FD9D7134_10C61A5C |   854K|    36M|	     |  4417   (1)| 00:00:53 |
|  13 |     VIEW		               |				                     |   854K|    36M|	     |  4417   (1)| 00:00:53 |
|  14 |      TABLE ACCESS FULL	   | SYS_TEMP_0FD9D7134_10C61A5C |   854K|    36M|	     |  4417   (1)| 00:00:53 |
------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("TITLE"="CASTS"."TITLE")
   8 - access("B"."EACHMONTH"="C"."EACHMONTH" AND "B"."TOTALTAPS"="C"."MAXTAPS")

Note
-----
   - dynamic sampling used for this statement (level=2)


Statistics
----------------------------------------------------------
	192  recursive calls
	324  db block gets
 2675  consistent gets
	453  physical reads
 1788  redo size
	692  bytes sent via SQL*Net to client
	350  bytes received via SQL*Net from client
	  2  SQL*Net roundtrips to/from client
	  1  sorts (memory)
	  0  sorts (disk)
	 12  rows processed
*/

CREATE INDEX seasons_title_index ON SEASONS (TITLE);
CREATE INDEX movies_country_index ON MOVIES (COUNTRY);
--CREATE INDEX contracts_enddate_index ON CONTRACTS (ENDDATE);
CREATE INDEX products_type_and_name_index ON PRODUCTS (TYPE, PRODUCT_NAME);

--INDEX DE LA FUNCTION
CREATE INDEX function_startdatenddate_index ON CONTRACTS (CLIENTID, ENDDATE, STARTDATE);

CREATE INDEX movies_duration_index ON MOVIES (DURATION);
CREATE INDEX series_avgduration_index ON SEASONS (AVGDURATION);--este no sirve de na

--INDEX de prueba que lo mismo explotan
CREATE INDEX lic_movies_client_title_index ON LIC_MOVIES (TITLE);
CREATE INDEX lic_series_clien_more_index ON LIC_SERIES (CLIENT, TITLE, EPISODE, SEASON);
CREATE INDEX clients_name_surname_sec_index ON CLIENTS(NAME, SURNAME. SEC_SURNAME);
