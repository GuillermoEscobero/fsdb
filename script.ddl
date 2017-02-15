-- Generado por Oracle SQL Developer Data Modeler 4.1.5.907
--   en:        2017-02-15 22:05:30 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g




CREATE TABLE Clients
  (
    id           INTEGER NOT NULL ,
    email        VARCHAR2 (200 CHAR) NOT NULL ,
    name         VARCHAR2 (50 CHAR) NOT NULL ,
    surname      VARCHAR2 (50 CHAR) NOT NULL ,
    surname2     VARCHAR2 (50 CHAR) ,
    phone_number INTEGER NOT NULL ,
    postal_code  INTEGER NOT NULL ,
    city         VARCHAR2 (100 CHAR) NOT NULL ,
    address      VARCHAR2 (150 CHAR) NOT NULL
  ) ;
ALTER TABLE Clients ADD CONSTRAINT Clients_PK PRIMARY KEY ( id ) ;
ALTER TABLE Clients ADD CONSTRAINT Clients__UNv1 UNIQUE ( email , phone_number ) ;


CREATE TABLE Contracts_active
  (
    id UNKNOWN
    --  ERROR: Datatype UNKNOWN is not allowed
    NOT NULL ,
    Clients_id INTEGER ,
    start_date UNKNOWN
    --  ERROR: Datatype UNKNOWN is not allowed
    NOT NULL ,
    end_date UNKNOWN
    --  ERROR: Datatype UNKNOWN is not allowed
    ,
    contract_type UNKNOWN
    --  ERROR: Datatype UNKNOWN is not allowed
    NOT NULL
  ) ;
ALTER TABLE Contracts_active ADD CONSTRAINT Contracts_PK PRIMARY KEY ( id ) ;


CREATE TABLE Contracts_all
  (
    Contracts_active_id UNKNOWN
    --  ERROR: Datatype UNKNOWN is not allowed
    NOT NULL
  ) ;
ALTER TABLE Contracts_all ADD CONSTRAINT Contracts_all_PK PRIMARY KEY ( Contracts_active_id ) ;


ALTER TABLE Contracts_active ADD CONSTRAINT Contracts_Clients_FK FOREIGN KEY ( Clients_id ) REFERENCES Clients ( id ) ;

--  ERROR: FK name length exceeds maximum allowed length(30)
ALTER TABLE Contracts_all ADD CONSTRAINT Contracts_all_Contracts_active_FK FOREIGN KEY ( Contracts_active_id ) REFERENCES Contracts_active ( id ) ;


-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             3
-- CREATE INDEX                             0
-- ALTER TABLE                              6
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   6
-- WARNINGS                                 0
