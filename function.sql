-- Bill a given month/year to a given customer with a given product;
-- Returns NUMBER (6.2).
CREATE OR REPLACE FUNCTION bill RETURN NUMBER
IS
    date_bill IN DATE,
    client IN VARCHAR2(XXX),
    product IN VARCHAR2(XXX))
    RETURN NUMBER
    IS total NUMBER(6,2);
  BEGIN
    SELECT FEE
    INTO total
    FROM CONTRACTS
    JOIN CLIENTS ON CONTRACTS.CLIENTID=CLIENTS.CLIENTID
    JOIN PRODUCTS ON CONTRACT_TYPE=TYPE
    WHERE (client=CONTRACTS.CLIENTID)
    AND (date_bill BETWEEN STARTDATE AND ENDDATE)
    AND (product=CONTRACTS.CONTRACT_TYPE);
    RETURN(total);
  END;
  /
