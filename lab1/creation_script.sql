-- LAB ASSIGNMENT FSDB 1

CREATE TABLE CLIENTS
  (
    CLIENTID     VARCHAR2 (15 CHAR) ,
    EMAIL        VARCHAR2 (100 CHAR) NOT NULL ,
    DNI          VARCHAR2 (9 CHAR) NOT NULL ,
    NAME         VARCHAR2 (100 CHAR) NOT NULL ,
    SURNAME      VARCHAR2 (100 CHAR) NOT NULL ,
    SEC_SURNAME  VARCHAR2 (100 CHAR) ,
    BIRTHDATE    DATE NOT NULL ,
    PHONEN       NUMBER(14) ,
    CONSTRAINT PK_CLIENTS PRIMARY KEY (CLIENTID) ,
    CONSTRAINT U_CLIENTS1 UNIQUE (EMAIL) ,
    CONSTRAINT U_CLIENTS2 UNIQUE (DNI) ,
    CONSTRAINT U_CLIENTS3 UNIQUE (PHONEN),
    CONSTRAINT CK_CLIENTS1 CHECK (REGEXP_LIKE(DNI, '^[0-9]{8}+[A-Za-z]{1}$')) ,
    CONSTRAINT CK_CLIENTS2 CHECK (REGEXP_LIKE(EMAIL, '^[A-Za-z]*[A-Za-z0-9._]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$')) ,
    CONSTRAINT CK_CLIENTS3 CHECK (PHONEN > 0)
  ) ;

CREATE TABLE PRODUCTS
  (
    NAME      VARCHAR2(50) ,
    FEE       NUMBER(4,1) NOT NULL ,
    TYPE      VARCHAR2(1) NOT NULL ,
    TAP_COST  NUMBER(4,2) NOT NULL ,
    ZAPP      NUMBER(2) DEFAULT 0 NOT NULL ,
    PPM       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    PPD       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    PROMO     NUMBER(3) DEFAULT 0 NOT NULL ,
    CONSTRAINT PK_PRODUCTS PRIMARY KEY (NAME) ,
    CONSTRAINT CK_PRODUCTS1 CHECK (TYPE IN ('C','V')) ,
    CONSTRAINT CK_PRODUCTS2 CHECK (PROMO BETWEEN 0 AND 100) ,
    CONSTRAINT CK_PRODUCTS3 CHECK (ZAPP BETWEEN 0 AND 99)
  ) ;

CREATE TABLE CONTRACTS
  (
    CONTRACTID    VARCHAR2 (10 CHAR) ,
    CLIENTID      VARCHAR2 (15 CHAR) NOT NULL ,
    ZIPCODE       VARCHAR2 (10 CHAR)  NOT NULL ,
    TOWN          VARCHAR2 (100 CHAR) NOT NULL ,
    ADDRESS       VARCHAR2 (150 CHAR) NOT NULL ,
    COUNTRY       VARCHAR2 (100 CHAR) NOT NULL ,
    STARTDATE     DATE NOT NULL ,
    ENDDATE       DATE ,
    CONTRACT_TYPE VARCHAR2 (50 CHAR) NOT NULL ,
    CONSTRAINT PK_CONTRACTS PRIMARY KEY (CONTRACTID) ,
    CONSTRAINT FK_CLIENTS        FOREIGN KEY (CLIENTID)      REFERENCES CLIENTS(CLIENTID) ,
    CONSTRAINT FK_CONTRACTS_TYPE FOREIGN KEY (CONTRACT_TYPE) REFERENCES PRODUCTS(NAME) ,
    CONSTRAINT CK_CONTRACTS CHECK (STARTDATE < ENDDATE)
  ) ;

CREATE VIEW EFFECTIVE_CONTRACTS AS SELECT * FROM CONTRACTS WHERE SYSDATE BETWEEN STARTDATE AND ENDDATE;

CREATE TABLE MOVIES
  (
    COLOR                      VARCHAR2(100 CHAR) ,
    DIRECTOR_NAME              VARCHAR2(100 CHAR) ,
    NUM_CRITIC_FOR_REVIEWS     NUMBER(3) ,
    DURATION                   NUMBER(3) ,
    DIRECTOR_FACEBOOK_LIKES    NUMBER(5) ,
    ACTOR_3_FACEBOOK_LIKES     NUMBER(5) ,
    ACTOR_2_NAME               VARCHAR2(100 CHAR) ,
    ACTOR_1_FACEBOOK_LIKES     NUMBER(6) ,
    GROSS                      NUMBER(9) ,
    GENRES                     VARCHAR2(100 CHAR) ,
    ACTOR_1_NAME               VARCHAR2(100 CHAR) ,
    MOVIE_TITLE                VARCHAR2(100 CHAR) ,
    NUM_VOTED_USERS            NUMBER(7) ,
    CAST_TOTAL_FACEBOOK_LIKES  NUMBER(6) ,
    ACTOR_3_NAME               VARCHAR2(100 CHAR) ,
    FACENUMBER_IN_POSTER       NUMBER(2) ,
    PLOT_KEYWORDS              VARCHAR2(150 CHAR) ,
    MOVIE_IMDB_LINK            VARCHAR2(100 CHAR) ,
    NUM_USER_FOR_REVIEWS       NUMBER(4) ,
    FILMING_LANGUAGE           VARCHAR2(100 CHAR) ,
    COUNTRY                    VARCHAR2(100 CHAR) ,
    CONTENT_RATING             VARCHAR2(100 CHAR) ,
    BUDGET                     NUMBER(10) ,
    TITLE_YEAR                 DATE ,
    ACTOR_2_FACEBOOK_LIKES     NUMBER(6) ,
    IMDB_SCORE                 NUMBER(3,1) ,
    ASPECT_RATIO               NUMBER(4,2) ,
    MOVIE_FACEBOOK_LIKES       NUMBER(6) ,
    CONSTRAINT PK_MOVIES PRIMARY KEY (MOVIE_TITLE) ,
    CONSTRAINT CK_MOVIES1 CHECK (COLOR IN ('Color','Black and White')) ,
    CONSTRAINT CK_MOVIES2 CHECK (DURATION > 0) ,
    CONSTRAINT CK_MOVIES3 CHECK (NUM_CRITIC_FOR_REVIEWS >= 0) ,
    CONSTRAINT CK_MOVIES4 CHECK (GROSS >= 0) ,
    CONSTRAINT CK_MOVIES5 CHECK (BUDGET >= 0) ,
    CONSTRAINT CK_MOVIES6 CHECK (TITLE_YEAR >= TO_DATE('1895-12-28', 'YYYY-MM-DD')) , -- FIRST MOVIE OF HISTORY
    CONSTRAINT CK_MOVIES7 CHECK (IMDB_SCORE BETWEEN 0.0 AND 10.0 ) ,
    CONSTRAINT CK_MOVIES8 CHECK (ASPECT_RATIO > 0) ,
    CONSTRAINT CK_MOVIES9 CHECK (CONTENT_RATING IN ('TV-14', 'R', 'Not Rated', 'Unrated', 'NC-17', 'PG-13', 'TV-MA', 'PG', 'TV-Y7', 'M', 'GP', 'TV-Y' ,'X', 'TV-PG', 'Passed', 'G','TV-G','Approved' )),
    CONSTRAINT CK_MOVIES10 CHECK (DIRECTOR_FACEBOOK_LIKES >= 0) ,
    CONSTRAINT CK_MOVIES11 CHECK (ACTOR_3_FACEBOOK_LIKES >= 0) ,
    CONSTRAINT CK_MOVIES12 CHECK (ACTOR_1_FACEBOOK_LIKES >= 0) ,
    CONSTRAINT CK_MOVIES13 CHECK (NUM_VOTED_USERS >= 0) ,
    CONSTRAINT CK_MOVIES14 CHECK (CAST_TOTAL_FACEBOOK_LIKES >= 0) ,
    CONSTRAINT CK_MOVIES15 CHECK (FACENUMBER_IN_POSTER >= 0) ,
    CONSTRAINT CK_MOVIES16 CHECK (NUM_USER_FOR_REVIEWS >= 0) ,
    CONSTRAINT CK_MOVIES17 CHECK (ACTOR_2_FACEBOOK_LIKES >= 0) ,
    CONSTRAINT CK_MOVIES18 CHECK (MOVIE_FACEBOOK_LIKES >= 0)
  ) ;

CREATE TABLE TVSERIES
  (
    TITLE         VARCHAR2(100 CHAR) ,
    TOTAL_SEASONS NUMBER(3) NOT NULL,
    SEASON        NUMBER(2) ,
    AVGDURATION   NUMBER(3) ,
    EPISODES      NUMBER(3) ,
    CONSTRAINT PK_TVSERIES PRIMARY KEY (TITLE, SEASON) ,
    CONSTRAINT CK_TVSERIES1 CHECK (TOTAL_SEASONS >= SEASON) ,
    CONSTRAINT CK_TVSERIES2 CHECK (TOTAL_SEASONS >= 0) ,
    CONSTRAINT CK_TVSERIES3 CHECK (SEASON >= 0) ,
    CONSTRAINT CK_TVSERIES4 CHECK (AVGDURATION >= 0) ,
    CONSTRAINT CK_TVSERIES5 CHECK (EPISODES >= 0)
  ) ;

CREATE TABLE TAPSTV
  (
    CLIENT   VARCHAR2(15 CHAR) ,
    TITLE  VARCHAR2(100 CHAR) ,
    DURATION NUMBER(3) ,
    SEASON   NUMBER(3) ,
    EPISODE  NUMBER(3) ,
    VIEWDATE DATE ,
    VIEWPCT  NUMBER(3) NOT NULL ,
    CONSTRAINT PK_TAPSTV PRIMARY KEY (CLIENT, TITLE, VIEWDATE, SEASON, EPISODE) ,
    CONSTRAINT FK_TAPSTV1 FOREIGN KEY (CLIENT) REFERENCES CLIENTS(CLIENTID) ,
    CONSTRAINT FK_TAPSTV2 FOREIGN KEY (TITLE, SEASON) REFERENCES TVSERIES(TITLE, SEASON) ,
    CONSTRAINT CK_TAPSTV1 CHECK (DURATION >= 0) ,
    CONSTRAINT CK_TAPSTV2 CHECK (SEASON >= 0) ,
    CONSTRAINT CK_TAPSTV3 CHECK (EPISODE >= 0) ,
    CONSTRAINT CK_TAPSTV4 CHECK (VIEWPCT BETWEEN 0 AND 100)
  ) ;

CREATE TABLE TAPSMOVIES
  (
    CLIENT   VARCHAR2(15 CHAR) ,
    TITLE    VARCHAR2(100 CHAR) ,
    VIEWDATE DATE ,
    DURATION NUMBER(3) ,
    VIEWPCT  NUMBER(3) NOT NULL ,
    CONSTRAINT PK_TAPSMOVIES PRIMARY KEY (CLIENT, TITLE, VIEWDATE) ,
    CONSTRAINT FK_TAPSMOVIES1 FOREIGN KEY (CLIENT) REFERENCES CLIENTS(CLIENTID) ,
    CONSTRAINT FK_TAPSMOVIES2 FOREIGN KEY (TITLE) REFERENCES MOVIES(MOVIE_TITLE) ,
    CONSTRAINT CK_TAPSMOVIES1 CHECK (VIEWPCT BETWEEN 0 AND 100)
  ) ;

CREATE TABLE PURCHASEDMOVIES
  (
    CLIENTID      VARCHAR2(15 CHAR) ,
    TITLE         VARCHAR2(100 CHAR) ,
    PURCHASE_DATE DATE ,
    CONSTRAINT PK_PURCHASEDMOVIES PRIMARY KEY (CLIENTID, PURCHASE_DATE) ,
    CONSTRAINT FK_PURCHASEDMOVIES1 FOREIGN KEY (TITLE) REFERENCES MOVIES(MOVIE_TITLE) ,
    CONSTRAINT FK_PURCHASEDMOVIES2 FOREIGN KEY (CLIENTID) REFERENCES CLIENTS(CLIENTID)
  ) ;

CREATE TABLE PURCHASEDTVSERIES
  (
    CLIENTID      VARCHAR2(15 CHAR) ,
    TITLE         VARCHAR2(100 CHAR) NOT NULL,
    PURCHASE_DATE DATE ,
    SEASON        NUMBER(2) NOT NULL ,
    EPISODE       NUMBER(3) NOT NULL ,
    CONSTRAINT PK_PURCHASEDTVSERIES PRIMARY KEY (CLIENTID, PURCHASE_DATE) ,
    CONSTRAINT FK_PURCHASEDTVSERIES1 FOREIGN KEY (TITLE, SEASON) REFERENCES TVSERIES(TITLE, SEASON) ,
    CONSTRAINT FK_PURCHASEDTVSERIES2 FOREIGN KEY (CLIENTID) REFERENCES CLIENTS(CLIENTID)
  ) ;

CREATE TABLE MOVIELICENSES
  (
    CLIENTID      VARCHAR2(15 CHAR) ,
    TITLE         VARCHAR2(100 CHAR) NOT NULL,
    PURCHASE_DATE DATE ,
    CONSTRAINT PK_MOVIELICENSES PRIMARY KEY (CLIENTID, PURCHASE_DATE) ,
    CONSTRAINT FK_MOVIELICENSES1 FOREIGN KEY (TITLE) REFERENCES MOVIES(MOVIE_TITLE) ,
    CONSTRAINT FK_MOVIELICENSES2 FOREIGN KEY (CLIENTID) REFERENCES CLIENTS(CLIENTID)
  ) ;

CREATE TABLE TVSERIESLICENSES
  (
    CLIENTID      VARCHAR2(15 CHAR) ,
    TITLE         VARCHAR2(100 CHAR) NOT NULL,
    SEASON        NUMBER(2) NOT NULL ,
    EPISODE       NUMBER(3) NOT NULL ,
    PURCHASE_DATE DATE ,
    CONSTRAINT PK_TVSERIESLICENSES PRIMARY KEY (CLIENTID, PURCHASE_DATE) ,
    CONSTRAINT FK_TVSERIESLICENSES1 FOREIGN KEY (TITLE, SEASON) REFERENCES TVSERIES(TITLE, SEASON) ,
    CONSTRAINT FK_TVSERIESLICENSES2 FOREIGN KEY (CLIENTID) REFERENCES CLIENTS(CLIENTID)
  ) ;

--545342 EN OLD_TAPS
--230929 EN TVTAPS
--313474 EN MOVIETAPS
--544403 EN TOTAL (939 MENOS)
