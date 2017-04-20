-- Bill a given month/year to a given customer with a given product;
-- Returns NUMBER (6.2).

CREATE OR REPLACE FUNCTION BILL(client_id VARCHAR2, PERIOD_TO_BILL VARCHAR2, product_type VARCHAR2)
  RETURN NUMBER
IS
  TOTAL_PRICE           NUMBER(6, 2); --coste total a cobrar(returning value)
  COST_OF_MOVIES        NUMBER;
  COST_OF_SERIES        NUMBER;
  END_DATE_OF_PROMOTION DATE;
  PPD                   NUMBER;

  --CURSOR TO GET THE TABLE REGARDING MOVIES CONSUMED IN THE MONTH PROVIDED
  CURSOR BILL_ALL_MOVIES (CLIENT_ID VARCHAR2, PERIOD_TO_BILL VARCHAR2, PRODUCT_TYPE VARCHAR2)
  IS
    SELECT
      CLIENTID,
      CONTRACTID,
      MOVIE_DURATION,
      PRODUCT_NAME,
      VIEW_DATETIME,
      TYPE,
      ZAPP,
      PP,
      PPM,
      PPD,
      PCT,
      DATETIME AS PURCHASE_DATETIME,
      CONTRACT_STARTDATE
    FROM
      (
        SELECT
          CLIENTID,
          CONTRACTID,
          DURATION AS MOVIE_DURATION,
          PRODUCT_NAME,
          VIEW_DATETIME,
          TYPE,
          ZAPP,
          PP,
          PPM,
          PPD,
          PCT,
          TITLE    AS MOVIE_TITLE,
          CONTRACT_STARTDATE
        FROM
          (
            SELECT
              CLIENTID,
              CONTRACTID,
              TITLE,
              PRODUCT_NAME,
              VIEW_DATETIME,
              TYPE,
              ZAPP,
              TAP_COST AS PP,
              PPM,
              PPD,
              PCT,
              CONTRACT_STARTDATE
            FROM
              (
                SELECT
                  CLIENTID,
                  CONTRACTID,
                  TITLE,
                  CONTRACT_TYPE,
                  VIEW_DATETIME,
                  PCT,
                  STARTDATE AS CONTRACT_STARTDATE
                FROM
                  (
                    SELECT
                      TITLE,
                      CONTRACTID,
                      VIEW_DATETIME,
                      PCT
                    FROM TAPS_MOVIES
                    )
                  NATURAL JOIN CONTRACTS
                )
              JOIN PRODUCTS ON PRODUCT_NAME = CONTRACT_TYPE
            WHERE (CLIENTID = CLIENT_ID AND TO_CHAR(VIEW_DATETIME, 'MON-YYYY') = PERIOD_TO_BILL AND
                   PRODUCT_NAME = PRODUCT_TYPE)
            )
          JOIN MOVIES ON TITLE = MOVIE_TITLE
        )
      LEFT OUTER JOIN LIC_MOVIES ON MOVIE_TITLE = TITLE AND CLIENTID = CLIENT;

  --CURSOR TO GET THE TABLE REGARDING SERIES CONSUMED IN THE MONTH PROVIDED
  CURSOR BILL_ALL_SERIES (CLIENT_ID VARCHAR2, PERIOD_TO_BILL VARCHAR2, PRODUCT_TYPE VARCHAR2)
  IS
    SELECT
      CLIENTID,
      CONTRACTID,
      PRODUCT_NAME,
      VIEW_DATETIME,
      TYPE,
      ZAPP,
      PP,
      PPM,
      PPD,
      SEASON_SERIES,
      SERIES_TITLE,
      AVGDURATION,
      PCT,
      DATETIME AS PURCHASE_DATETIME,
      SERIES_EPISODE
    FROM
      (
        SELECT
          CLIENTID,
          CONTRACTID,
          PRODUCT_NAME,
          VIEW_DATETIME,
          TYPE,
          ZAPP,
          TAP_COST AS PP,
          PPM,
          PPD,
          SEASON_SERIES,
          SERIES_TITLE,
          AVGDURATION,
          PCT,
          SERIES_EPISODE
        FROM
          (
            SELECT
              CLIENTID,
              CONTRACTID,
              CONTRACT_TYPE,
              VIEW_DATETIME,
              SEASON_SERIES,
              SERIES_TITLE,
              AVGDURATION,
              PCT,
              SERIES_EPISODE
            FROM
              (
                SELECT
                  CONTRACTID,
                  VIEW_DATETIME,
                  SEASON AS SEASON_SERIES,
                  SERIES_TITLE,
                  AVGDURATION,
                  PCT,
                  SERIES_EPISODE
                FROM
                  (
                    SELECT
                      CONTRACTID,
                      VIEW_DATETIME,
                      TITLE   AS SERIES_TITLE,
                      PCT,
                      SEASON  AS SEASON_SERIES,
                      EPISODE AS SERIES_EPISODE
                    FROM TAPS_SERIES
                    )
                  JOIN SEASONS
                    ON TITLE = SERIES_TITLE AND SEASON = SEASON_SERIES
                )
              NATURAL JOIN CONTRACTS
            )
          JOIN PRODUCTS ON PRODUCT_NAME = CONTRACT_TYPE
        WHERE
          (CLIENTID = CLIENT_ID AND TO_CHAR(VIEW_DATETIME, 'MON-YYYY') = PERIOD_TO_BILL AND PRODUCT_NAME = PRODUCT_TYPE)
        )
      LEFT OUTER JOIN LIC_SERIES
        ON SERIES_TITLE = TITLE AND CLIENTID = CLIENT AND SERIES_EPISODE = EPISODE AND SEASON_SERIES = SEASON;

  --CURSOR TO OBTAIN THE CONTRACT INFO TO APPLY A PROMOTION IF CONSIDERED
  CURSOR CHECK_PROMOTION (CLIENT_ID VARCHAR2, PRODUCT_TYPE VARCHAR2)
  IS
    SELECT
      STARTDATE,
      ENDDATE,
      CONTRACT_TYPE,
      PROMO
    FROM
      (
        SELECT
          STARTDATE,
          ENDDATE,
          CONTRACT_TYPE
        FROM CONTRACTS
        WHERE CLIENTID = CLIENT_ID AND CONTRACT_TYPE = PRODUCT_TYPE
        )
      JOIN PRODUCTS ON PRODUCT_NAME = CONTRACT_TYPE;

  --CURSOR
  CURSOR GET_TAPS_PER_DAY (CLIENT_ID VARCHAR2, PERIOD_TO_BILL VARCHAR2, PRODUCT_TYPE VARCHAR2)
  IS
    SELECT COUNT(*) AS DAYS_WITH_TAPS
    FROM
      (
        SELECT
          TO_CHAR(VIEW_DATETIME, 'DD-MON-YYYY') AS TAP_DATE,
          CONTRACT_ID
        FROM
          (
            (
              SELECT
                CONTRACT_ID,
                VIEW_DATETIME
              FROM
                (
                  SELECT CONTRACTID AS CONTRACT_ID
                  FROM
                    CONTRACTS
                  WHERE CLIENTID = CLIENT_ID AND CONTRACT_TYPE = PRODUCT_TYPE
                  )
                JOIN TAPS_MOVIES ON CONTRACTID = CONTRACT_ID
            )
            UNION
            (
              SELECT
                CONTRACT_ID,
                VIEW_DATETIME
              FROM
                (
                  SELECT CONTRACTID AS CONTRACT_ID
                  FROM
                    CONTRACTS
                  WHERE CLIENTID = CLIENT_ID AND CONTRACT_TYPE = PRODUCT_TYPE
                  )
                JOIN TAPS_SERIES ON CONTRACTID = CONTRACT_ID
            )
          )
        GROUP BY TO_CHAR(VIEW_DATETIME, 'DD-MON-YYYY'), CONTRACT_ID
        HAVING TO_CHAR(TO_DATE(TO_CHAR(VIEW_DATETIME, 'DD-MON-YYYY'), 'DD-MON-YYYY'), 'MON-YYYY') = PERIOD_TO_BILL
      )
    GROUP BY CONTRACT_ID;

  --BEGIN WITH THE FUNCTION
  BEGIN
    TOTAL_PRICE := 0;
    COST_OF_MOVIES := 0;
    COST_OF_SERIES := 0;
    PPD := 0;

    FOR CLIENTID IN BILL_ALL_MOVIES(CLIENT_ID, PERIOD_TO_BILL, PRODUCT_TYPE)
    LOOP
      PPD := CLIENTID.PPD;
      IF CLIENTID.ZAPP <= CLIENTID.PCT
      THEN
        CASE CLIENTID.TYPE
          WHEN 'V'
          THEN COST_OF_MOVIES :=
          COST_OF_MOVIES + CLIENTID.PP * 2 + CLIENTID.PPM * CEIL(CLIENTID.MOVIE_DURATION * CLIENTID.PCT / 100);
          WHEN 'C'
          THEN
            --CHECK IF THE CONTENT IS PURCHASED, IF IT IS NOT, CHARGE THE USER WITH IT
            IF (CLIENTID.PURCHASE_DATETIME IS NULL OR CLIENTID.PURCHASE_DATETIME >= CLIENTID.VIEW_DATETIME)
            THEN
              COST_OF_MOVIES := COST_OF_MOVIES + CLIENTID.PP * 2 + CLIENTID.PPM * CLIENTID.MOVIE_DURATION;
            END IF;
        END CASE;
      END IF;
    END LOOP;

    FOR CLIENTID IN BILL_ALL_SERIES(CLIENT_ID, PERIOD_TO_BILL, PRODUCT_TYPE)
    LOOP
      IF CLIENTID.ZAPP <= CLIENTID.PCT
      THEN
        CASE CLIENTID.TYPE
          WHEN 'V'
          THEN COST_OF_SERIES :=
          COST_OF_SERIES + CLIENTID.PP + CLIENTID.PPM * CEIL(CLIENTID.AVGDURATION * CLIENTID.PCT / 100);
          WHEN 'C'
          THEN
            --CHECK IF THE CONTENT IS PURCHASED, IF IT IS NOT, CHARGE THE USER WITH IT
            IF (CLIENTID.PURCHASE_DATETIME IS NULL OR CLIENTID.PURCHASE_DATETIME >= CLIENTID.VIEW_DATETIME)
            THEN
              COST_OF_SERIES := COST_OF_SERIES + CLIENTID.PP + CLIENTID.PPM * CLIENTID.AVGDURATION;
            END IF;
        END CASE;
      END IF;
    END LOOP;

    TOTAL_PRICE := COST_OF_MOVIES + COST_OF_SERIES;

    CASE PRODUCT_TYPE
      WHEN 'Free Rider'
      THEN TOTAL_PRICE := TOTAL_PRICE + 10;
      WHEN 'Premium Rider'
      THEN TOTAL_PRICE := TOTAL_PRICE + 39;
      WHEN 'TVrider'
      THEN TOTAL_PRICE := TOTAL_PRICE + 29;
      WHEN 'Flat Rate Lover'
      THEN TOTAL_PRICE := TOTAL_PRICE + 39;
      WHEN 'Short Timer'
      THEN TOTAL_PRICE := TOTAL_PRICE + 15;
      WHEN 'Content Master'
      THEN TOTAL_PRICE := TOTAL_PRICE + 20;
      WHEN 'Boredom Fighter'
      THEN TOTAL_PRICE := TOTAL_PRICE + 10;
      WHEN 'Low Cost Rate'
      THEN TOTAL_PRICE := TOTAL_PRICE + 0;
    END CASE;

    --COUNT THE NUMBER OF DAYS THAT A TAP HAS BEEN CREATED, IN ORDER TO CHARGE PPD FEE
    FOR X IN GET_TAPS_PER_DAY(CLIENT_ID, PERIOD_TO_BILL, PRODUCT_TYPE)
    LOOP
      TOTAL_PRICE := TOTAL_PRICE + X.DAYS_WITH_TAPS * PPD;
    END LOOP;

    --CHECK IF THE CURRENT MONTH IS ELEGIBLE FOR A PROMOTION
    --SACAR DIAS DE DURACION CONTRATO / 8 PARA SACAR EL NUMERO DE DIAS QUE DURA LA PROMOCION AL PRINCIPIIO DEL CONTRATO
    FOR CLIENTID IN CHECK_PROMOTION(CLIENT_ID, PRODUCT_TYPE)
    LOOP
      END_DATE_OF_PROMOTION := CLIENTID.STARTDATE + ROUND((CLIENTID.ENDDATE - CLIENTID.STARTDATE) / 8, 0);
      IF CLIENTID.ENDDATE IS NOT NULL AND
         (TO_DATE(PERIOD_TO_BILL, 'MON-YYYY') BETWEEN TO_DATE(TO_CHAR(CLIENTID.STARTDATE, 'MON-YYYY'), 'MON-YYYY') AND
         TO_DATE(TO_CHAR(END_DATE_OF_PROMOTION, 'MON-YYYY'), 'MON-YYYY'))
      THEN
        TOTAL_PRICE := TOTAL_PRICE - CLIENTID.PROMO / 100 * TOTAL_PRICE;

      END IF;
    END LOOP;

    RETURN TOTAL_PRICE;
  END;
/
