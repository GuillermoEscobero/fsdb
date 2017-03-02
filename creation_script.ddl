-- LAB ASSIGNMENT FSDB 1

CREATE TABLE Clients
  (
    clientid     VARCHAR2 (15 CHAR) ,
    email        VARCHAR2 (100 CHAR) NOT NULL ,
    dni          VARCHAR2 (9 CHAR) NOT NULL ,
    name         VARCHAR2 (100 CHAR) NOT NULL ,
    surname      VARCHAR2 (100 CHAR) NOT NULL ,
    sec_surname  VARCHAR2 (100 CHAR) ,
    birthdate    DATE NOT NULL ,
    phonen       NUMBER(14) ,
    zipcode      VARCHAR2 (10 CHAR)  NOT NULL ,
    town         VARCHAR2 (100 CHAR) NOT NULL ,
    address      VARCHAR2 (150 CHAR) NOT NULL ,
    country      VARCHAR2 (100 CHAR) NOT NULL ,
    CONSTRAINT PK_clients PRIMARY KEY (clientid) ,
	CONSTRAINT U_clients1 UNIQUE (email) ,
	CONSTRAINT U_clients2 UNIQUE (dni) ,
	CONSTRAINT U_clients3 UNIQUE (phonen)
	) ;

CREATE TABLE Contracts_types
  (
    name      VARCHAR2(50) ,
    fee       NUMBER(4,1) NOT NULL ,
    type      VARCHAR2(1) NOT NULL ,
    tap_cost  NUMBER(4,2) NOT NULL ,
    zapp      NUMBER(2) DEFAULT 0 NOT NULL ,
    ppm       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    ppd       NUMBER(4,2) DEFAULT 0 NOT NULL ,
    promo     NUMBER(3) DEFAULT 0 NOT NULL ,
    CONSTRAINT PK_products PRIMARY KEY (name) ,
    CONSTRAINT CK_products1 CHECK (type IN ('C','V')) ,
    CONSTRAINT CK_products2 CHECK (PROMO between 0 and 100) ,
    CONSTRAINT CK_products3 CHECK (ZAPP between 0 and 99)
) ;

CREATE TABLE Contracts
  (
    contractid    VARCHAR2 (10 CHAR) ,
    clientid      VARCHAR(15 CHAR) NOT NULL , -- Esto con el trigger al insertar, porque luego se puede borrar si lo piden
    startdate     DATE NOT NULL ,
    enddate       DATE ,
    contract_type VARCHAR2 (50 CHAR) NOT NULL ,
    CONSTRAINT PK_contracts PRIMARY KEY (contractid) ,
    CONSTRAINT FK_clients        FOREIGN KEY (clientid)      REFERENCES Clients(clientid) ,
    CONSTRAINT FK_contracts_type FOREIGN KEY (contract_type) REFERENCES Contracts_types(name) ,
    CONSTRAINT CH_contracts CHECK (startdate < enddate)
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
   MOVIE_FACEBOOK_LIKES       VARCHAR2(100 CHAR) ,
   CONSTRAINT CK_movies1 CHECK (COLOR IN ('Color','Black and White')),--, NULL))
   CONSTRAINT PK_movies PRIMARY KEY (MOVIE_TITLE, DIRECTOR_NAME)
  ) ;

CREATE TABLE TVSeries
  (
   TITLE         VARCHAR2(100 CHAR) ,
   TOTAL_SEASONS NUMBER(3) ,
   SEASON        NUMBER(3) ,
   AVGDURATION   NUMBER(3) ,
   EPISODES      NUMBER(3) ,
   CONSTRAINT CH_TVseries CHECK (TOTAL_SEASONS <= SEASON) ,
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
   VIEWPCT  VARCHAR2(5 CHAR) ,
   
  ) ;
