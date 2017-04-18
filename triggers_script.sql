-------------------------------------------------------------------------------
-- triggers_script.sql
-- 		Guillermo Escobero (100346060)
-- 		Raul Olmedo Checa (100346073)
-------------------------------------------------------------------------------

-- b) Prevent non-valid visualizations regarding contracts (there cannot be taps
-- in a date out of contract).
CREATE OR REPLACE TRIGGER NON_VALID_TAP_MOVIES
BEFORE INSERT ON taps_movies
FOR EACH ROW
  DECLARE
    contractid VARCHAR2(10 CHAR);
    startdate DATE;
    enddate DATE;
  BEGIN
    SELECT contractid, startdate, enddate INTO contractid, startdate, enddate
    FROM contracts
    WHERE contractid = :NEW.contractid;
    IF NOT ((:NEW.view_datetime BETWEEN startdate AND enddate)
      OR (enddate IS NULL AND startdate<=:NEW.view_datetime)) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tap date out of contract');
    END IF;
  END;

CREATE OR REPLACE TRIGGER NON_VALID_TAP_SERIES
BEFORE INSERT ON taps_series
FOR EACH ROW
  DECLARE
    contractid VARCHAR2(10 CHAR);
    startdate DATE;
    enddate DATE;
  BEGIN
    SELECT contractid, startdate, enddate INTO contractid, startdate, enddate
    FROM contracts
    WHERE contractid = :NEW.contractid;
    IF NOT ((:NEW.view_datetime BETWEEN startdate AND enddate)
      OR (enddate IS NULL AND startdate<=:NEW.view_datetime)) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Tap date out of contract');
    END IF;
  END;

----- Tests --------------------------------------------------------------------
-- INSERT INTO TAPS_MOVIES values('FJ95311/14', TO_DATE('2016-05-08','YYYY-MM-DD'), 132, 'Inception');
-- INSERT INTO TAPS_MOVIES values('FJ95311/14', TO_DATE('2018-05-08','YYYY-MM-DD'), 132, 'Inception');
-- INSERT INTO TAPS_MOVIES values('FJ95311/14', TO_DATE('2016-05-08','YYYY-MM-DD'), 132, 'Inceptionn');

-- DELETE FROM TAPS_MOVIES WHERE CONTRACTID='FJ95311/14' AND PCT=132 AND TITLE='Inception';
--------------------------------------------------------------------------------
