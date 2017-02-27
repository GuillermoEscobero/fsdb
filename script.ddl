-- LAB ASSIGNMENT FSDB 1

CREATE TABLE Clients
  (
    clientid     VARCHAR2 (15 CHAR) ,
    email        VARCHAR2 (100 CHAR) NOT NULL UNIQUE ,
    dni          VARCHAR2 (9 CHAR) NOT NULL UNIQUE,
    name         VARCHAR2 (100 CHAR) NOT NULL ,
    surname      VARCHAR2 (100 CHAR) NOT NULL ,
    sec_surname  VARCHAR2 (100 CHAR) ,
    birthdate    DATE NOT NULL , -- CHECK BIRTHDATE < SYS.CURRENT_DATE (Igual es con trigger) AL IMPORTARLO USAMOS TODATE()
    age          NUMBER(3,0) NOT NULL , -- Igual se puede sacar con una funcion, es redundante
    phonen       NUMBER(14,0) NOT NULL UNIQUE , -- Ver aquí tema prefijos de países
    zipcode      VARCHAR2 (10 CHAR)  NOT NULL ,
    town         VARCHAR2 (100 CHAR) NOT NULL ,
    address      VARCHAR2 (150 CHAR) NOT NULL ,
    country      VARCHAR2 (100 CHAR) NOT NULL ,

    CONSTRAINT PK_clients PRIMARY KEY (clientid)
  ) ;

CREATE TABLE Contracts_types
  (
    name 	    VARCHAR2(50) ,
    fee		    NUMBER(4,1) NOT NULL ,
    type		  VARCHAR2(1) NOT NULL ,
    tap_cost	NUMBER(4,2) NOT NULL ,
    zapp		  NUMBER(2) DEFAULT 0 NOT NULL ,
    ppm		    NUMBER(4,2) DEFAULT 0 NOT NULL ,
    ppd		    NUMBER(4,2) DEFAULT 0 NOT NULL ,
    promo		  NUMBER(3) DEFAULT 0 NOT NULL ,

    CONSTRAINT PK_products PRIMARY KEY (name) ,
    CONSTRAINT CK_products1 CHECK (type IN ('C','V')) ,
    CONSTRAINT CK_products2 CHECK (PROMO between 0 and  100) ,
    CONSTRAINT CK_products3 CHECK (ZAPP between 0 and  99)
) ;

--INSERT INTO products VALUES('Free Rider',10,'C',2.5,5,0,0.95,5);
--INSERT INTO products VALUES('Premium Rider',39,'V',0.5,0,0.01,0,3);
--INSERT INTO products VALUES('TVrider',29,'C',2,8,0,0.5,0);
--INSERT INTO products VALUES('Flat Rate Lover',39,'C',2.5,0,0,0,5);
--INSERT INTO products VALUES('Short Timer',15,'C',2.5,5,0.01,0,3);
--INSERT INTO products VALUES('Content Master',20,'C',1.75,4,1.02,0,3);
--INSERT INTO products VALUES('Boredom Fighter',10,'V',1,1,0,0.95,0);
--INSERT INTO products VALUES('Low Cost Rate',0,'V',0.95,4,0,1.45,3);

CREATE TABLE Contracts
  (
    contractid    VARCHAR2 (10 CHAR) ,
    clientid      VARCHAR(15 CHAR) NOT NULL ,
    startdate     DATE NOT NULL ,
    enddate       DATE ,
    contract_type VARCHAR2 (50 CHAR) NOT NULL ,

    CONSTRAINT PK_contracts PRIMARY KEY (contractid) ,
    CONSTRAINT FK_clients        FOREIGN KEY (clientid)      REFERENCES Clients(clientid) ,
    CONSTRAINT FK_contracts_type FOREIGN KEY (contract_type) REFERENCES Contracts_types(name)
    --CONSTRAINT CHECK (start_date < end_date) Todas estas comprobaciones van con triggers de fijo al INSERT o UPDATE
  ) ;

CREATE TABLE Movies
  (
   COLOR                      VARCHAR2(100 CHAR) ,
   DIRECTOR_NAME              VARCHAR2(100 CHAR) ,
   NUM_CRITIC_FOR_REVIEWS     VARCHAR2(100 CHAR) ,
   DURATION                   VARCHAR2(100 CHAR) ,
   DIRECTOR_FACEBOOK_LIKES    VARCHAR2(100 CHAR) ,
   ACTOR_3_FACEBOOK_LIKES     VARCHAR2(100 CHAR) ,
   ACTOR_2_NAME               VARCHAR2(100 CHAR) ,
   ACTOR_1_FACEBOOK_LIKES     VARCHAR2(100 CHAR) ,
   GROSS                      VARCHAR2(100 CHAR) ,
   GENRES                     VARCHAR2(100 CHAR) ,
   ACTOR_1_NAME               VARCHAR2(100 CHAR) ,
   MOVIE_TITLE                VARCHAR2(100 CHAR) ,
   NUM_VOTED_USERS            VARCHAR2(100 CHAR) ,
   CAST_TOTAL_FACEBOOK_LIKES  VARCHAR2(100 CHAR) ,
   ACTOR_3_NAME               VARCHAR2(100 CHAR) ,
   FACENUMBER_IN_POSTER       VARCHAR2(100 CHAR) ,
   PLOT_KEYWORDS              VARCHAR2(150 CHAR) ,
   MOVIE_IMDB_LINK            VARCHAR2(100 CHAR) ,
   NUM_USER_FOR_REVIEWS       VARCHAR2(100 CHAR) ,
   FILMING_LANGUAGE           VARCHAR2(100 CHAR) ,
   COUNTRY                    VARCHAR2(100 CHAR) ,
   CONTENT_RATING             VARCHAR2(100 CHAR) ,
   BUDGET                     VARCHAR2(100 CHAR) ,
   TITLE_YEAR                 VARCHAR2(100 CHAR) ,
   ACTOR_2_FACEBOOK_LIKES     VARCHAR2(100 CHAR) ,
   IMDB_SCORE                 VARCHAR2(100 CHAR) ,
   ASPECT_RATIO               VARCHAR2(100 CHAR) ,
   MOVIE_FACEBOOK_LIKES       VARCHAR2(100 CHAR)
  ) ;

CREATE TABLE TVSeries
  (
   TITLE         VARCHAR2(100 CHAR) PRIMARY KEY ,
   TOTAL_SEASONS NUMBER(3) ,
   SEASON        NUMBER(3) ,
   AVGDURATION   NUMBER(3) ,
   EPISODES      NUMBER(3) ,

   CONSTRAINT PK_TVseries PRIMARY KEY (TITLE)
  ) ;

CREATE TABLE Taps
  (
   CLIENT   VARCHAR2(15 CHAR) ,
   TITLE    VARCHAR2(100 CHAR) ,
   DURATION NUMBER(15) ,
   SEASON   NUMBER(15) ,
   EPISODE  NUMBER(15) ,
   VIEWDATE VARCHAR2(10 CHAR) ,
   VIEWHOUR VARCHAR2(5 CHAR) ,
   VIEWPCT  VARCHAR2(5 CHAR)
  ) ;
