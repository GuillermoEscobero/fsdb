-------------------------------------------------------
-- MODIFIED BY Raul Olmedo & Guillermo Escobero
-- Group 89 UC3M
-------------------------------------------------------

-- ----------------------------------------------------
-- ----------------------------------------------------
-- -- TABLES CREATION SCRIPT -- ASSIGNMENT SOLUTION ---
-- ----------------------------------------------------
-- ----------------------------------------------------
-- -- Course: File Structures and DataBases -----------
-- ----------------------------------------------------
-- -- (c) 2017 Dolores Cuadra & Javier Calle ----------
-- ------ Carlos III University of Madrid -------------
-- ----------------------------------------------------


-- ----------------------------------------------------
-- -- Part I: Destroy (in case) existent tables -------
-- ----------------------------------------------------

DROP TABLE MOVIES CASCADE CONSTRAINTS;
DROP TABLE GENRES_MOVIES CASCADE CONSTRAINTS;
DROP TABLE keywords_movies CASCADE CONSTRAINTS;
DROP TABLE PLAYERS CASCADE CONSTRAINTS;
DROP TABLE CASTS CASCADE CONSTRAINTS;
DROP TABLE SERIES CASCADE CONSTRAINTS;
DROP TABLE SEASONS CASCADE CONSTRAINTS;
DROP TABLE CLIENTS CASCADE CONSTRAINTS;
DROP TABLE PRODUCTS CASCADE CONSTRAINTS;
DROP TABLE CONTRACTS CASCADE CONSTRAINTS;
DROP TABLE TAPS_MOVIES CASCADE CONSTRAINTS;
DROP TABLE TAPS_SERIES CASCADE CONSTRAINTS;
DROP TABLE LIC_MOVIES CASCADE CONSTRAINTS;
DROP TABLE LIC_SERIES CASCADE CONSTRAINTS;
DROP TABLE INVOICES CASCADE CONSTRAINTS;

-- ----------------------------------------------------
-- -- Part IIa: Create clusters -----------------------
-- ----------------------------------------------------

CREATE CLUSTER CLIENT_CLUSTER (CLIENTID VARCHAR2(15));
CREATE CLUSTER MOVIE_CLUSTER (MOVIE_TITLE VARCHAR2(100));
CREATE CLUSTER CONTRACT_CLUSTER(CONTRACTID VARCHAR2(10));

-- ----------------------------------------------------
-- -- Part IIb: Create clusters' indexes --------------
-- ----------------------------------------------------

CREATE INDEX CLIENT_CLUSTER_INDEX ON CLUSTER CLIENT_CLUSTER;
CREATE INDEX MOVIE_CLUSTER_INDEX ON CLUSTER MOVIE_CLUSTER;
CREATE INDEX CONTRACT_CLUSTER_INDEX ON CLUSTER CONTRACT_CLUSTER;

-- ----------------------------------------------------
-- -- Part IIc: Create all tables ---------------------
-- ----------------------------------------------------

CREATE TABLE MOVIES(
movie_title       VARCHAR2(100),
title_year        NUMBER(4),
country           VARCHAR2(25),
color             VARCHAR2(1),
duration          NUMBER(3) NOT NULL,
gross             NUMBER(10),
budget            NUMBER(12),
director_name     VARCHAR2(50) DEFAULT 'Anonymous',
filming_language  VARCHAR2(20),
num_critic_for_reviews    NUMBER(6),
director_facebook_likes   NUMBER(6),
num_voted_users           NUMBER(7),
num_user_for_reviews      NUMBER(6),
cast_total_facebook_likes NUMBER(6),
facenumber_in_poster      NUMBER(6),
movie_imdb_link           VARCHAR2(60),
imdb_score                NUMBER(2,1),
content_rating            VARCHAR2(9),
aspect_ratio              NUMBER(4,2) ,
movie_facebook_likes      NUMBER(6),
CONSTRAINT MOVIES_PK PRIMARY KEY (movie_title),
CONSTRAINT MOVIES_CH CHECK (COLOR IN ('B','C', null))
)
CLUSTER MOVIE_CLUSTER(movie_title);


CREATE TABLE GENRES_MOVIES (
title	VARCHAR2(100),
genre	VARCHAR2(70),
CONSTRAINT PK_GENRES_MOVIES PRIMARY KEY (title,genre),
CONSTRAINT FK_GENRES_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
)
CLUSTER MOVIE_CLUSTER(title);



CREATE TABLE keywords_movies (
title		VARCHAR2(100),
keyword		VARCHAR2(150),
CONSTRAINT PK_KEYWORDS_MOVIES PRIMARY KEY (title,keyword),
CONSTRAINT FK_KEYWORDS_MOVIES FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE
)
CLUSTER MOVIE_CLUSTER(title);


CREATE TABLE PLAYERS (
actor_name      VARCHAR2(50),
facebook_likes  NUMBER(6,0),
CONSTRAINT ACTORS_PK PRIMARY KEY (actor_name));


CREATE TABLE CASTS (
actor   VARCHAR2(50),
title   VARCHAR2(100),
CONSTRAINT PK_CASTS PRIMARY KEY (actor, title),
CONSTRAINT FK1_CASTS FOREIGN KEY (actor) REFERENCES PLAYERS ON DELETE CASCADE,
CONSTRAINT FK2_CASTS FOREIGN KEY (title) REFERENCES MOVIES ON DELETE CASCADE)
CLUSTER MOVIE_CLUSTER(TITLE);


CREATE TABLE SERIES(
title        	VARCHAR2(100),
total_seasons 	NUMBER(3) NOT NULL,
CONSTRAINT PK_SERIES PRIMARY KEY (title)
);


CREATE TABLE SEASONS(
title        	VARCHAR2(100),
season 		NUMBER(3),
avgduration	NUMBER(3) NOT NULL,
episodes 	NUMBER(3) NOT NULL,
CONSTRAINT PK_SEASONS PRIMARY KEY (title, season),
CONSTRAINT FK_SEASONS FOREIGN KEY (title) REFERENCES SERIES ON DELETE CASCADE
);


CREATE TABLE CLIENTS (
clientId	VARCHAR2(15),
DNI		VARCHAR2(9),
name		VARCHAR2(100) NOT NULL,
surname		VARCHAR2(100) NOT NULL,
sec_surname	VARCHAR2(100),
eMail		VARCHAR2(100) NOT NULL,
phoneN		NUMBER(12),
birthdate	DATE,
CONSTRAINT PK_CLIENTS PRIMARY KEY (clientId),
CONSTRAINT UK1_CLIENTS UNIQUE (DNI),
CONSTRAINT UK2_CLIENTS UNIQUE (eMail),
CONSTRAINT UK3_CLIENTS UNIQUE (phoneN),
CONSTRAINT CH_CLIENTS CHECK (eMail LIKE '%@%.%')
)
CLUSTER CLIENT_CLUSTER(CLIENTID);


CREATE TABLE products(
product_name 	VARCHAR2(25),
fee		NUMBER(3) NOT NULL,
type		VARCHAR2(1) NOT NULL,
tap_cost	NUMBER(4,2) NOT NULL,
zapp		NUMBER(2) DEFAULT 0 NOT NULL,
ppm		NUMBER(4,2) DEFAULT 0 NOT NULL,
ppd		NUMBER(4,2) DEFAULT 0 NOT NULL,
promo		NUMBER(3) DEFAULT 0 NOT NULL,
CONSTRAINT PK_products PRIMARY KEY (product_name),
CONSTRAINT CK_products1 CHECK (type IN ('C','V')),
CONSTRAINT CK_products2 CHECK (PROMO <= 100)
);


CREATE TABLE contracts(
contractId VARCHAR2(10),
clientId  VARCHAR2(15),
startdate DATE NOT NULL,
enddate DATE,
contract_type VARCHAR2(25),
address		VARCHAR2(100) NOT NULL,
town		VARCHAR2(100) NOT NULL,
ZIPcode		VARCHAR2(8) NOT NULL,
country		VARCHAR2(100) NOT NULL,
CONSTRAINT PK_contracts PRIMARY KEY (contractId),
CONSTRAINT FK_contracts1 FOREIGN KEY (clientId) REFERENCES clientS ON DELETE SET NULL,
CONSTRAINT FK_contracts2 FOREIGN KEY (contract_type) REFERENCES products,
CONSTRAINT CK_contracts CHECK (startdate<=enddate)
)
CLUSTER CLIENT_CLUSTER(CLIENTID);


CREATE TABLE taps_movies(
contractId VARCHAR2(10),
view_datetime DATE,
pct	NUMBER(3) DEFAULT 0 NOT NULL,
title VARCHAR2(100) NOT NULL,
CONSTRAINT PK_tapsM PRIMARY KEY (contractId,title,view_datetime),
CONSTRAINT FK_tapsM1 FOREIGN KEY (contractId) REFERENCES contracts,
CONSTRAINT FK_tapsM2 FOREIGN KEY (title) REFERENCES movies
)
CLUSTER CONTRACT_CLUSTER(CONTRACTID);


CREATE TABLE taps_series(
contractId VARCHAR2(10),
view_datetime DATE,
pct	NUMBER(3) DEFAULT 0 NOT NULL,
title VARCHAR2(100) NOT NULL,
season  NUMBER(3) NOT NULL,
episode NUMBER(3) NOT NULL,
CONSTRAINT PK_tapsS PRIMARY KEY (contractId,title,season,episode,view_datetime),
CONSTRAINT FK_tapsS1 FOREIGN KEY (contractId) REFERENCES contracts,
CONSTRAINT FK_tapsS2 FOREIGN KEY (title,season) REFERENCES seasons
)
CLUSTER CONTRACT_CLUSTER(CONTRACTID);


CREATE TABLE lic_movies(
client VARCHAR2(15),
datetime DATE,
title VARCHAR2(100) NOT NULL,
CONSTRAINT PK_licsM PRIMARY KEY (client,title),
CONSTRAINT FK_licsM1 FOREIGN KEY (title) REFERENCES movies,
CONSTRAINT FK_licsM2 FOREIGN KEY (client) REFERENCES clients ON DELETE CASCADE
)
CLUSTER CLIENT_CLUSTER(CLIENT);


CREATE TABLE lic_series(
client VARCHAR2(15),
datetime DATE,
title VARCHAR2(100) NOT NULL,
season  NUMBER(3) NOT NULL,
episode NUMBER(3) NOT NULL,
CONSTRAINT PK_licsS PRIMARY KEY (client,title,season,episode),
CONSTRAINT FK_licsS1 FOREIGN KEY (title,season) REFERENCES seasons,
CONSTRAINT FK_licsS2 FOREIGN KEY (client) REFERENCES clients ON DELETE CASCADE
)
CLUSTER CLIENT_CLUSTER(CLIENT);

CREATE TABLE invoices(
clientId VARCHAR2(15),
month  VARCHAR2(2) ,
year  VARCHAR2(4) ,
amount NUMBER(8,2) NOT NULL,
CONSTRAINT PK_invcs PRIMARY KEY (clientId,month,year),
CONSTRAINT FK_invcs FOREIGN KEY (clientId) REFERENCES clients
)
CLUSTER CLIENT_CLUSTER(CLIENTID);

-- ----------------------------------------------------
-- -- Part IId: Create indexes ------------------------
-- ----------------------------------------------------

CREATE INDEX products_type_and_name_index ON PRODUCTS (TYPE, PRODUCT_NAME);
CREATE INDEX function_startdatenddate_index ON CONTRACTS (CLIENTID, ENDDATE, STARTDATE);
CREATE INDEX lic_movies_client_title_index ON LIC_MOVIES (TITLE);
CREATE INDEX lic_series_clien_more_index ON LIC_SERIES (CLIENT, TITLE, EPISODE, SEASON);
CREATE INDEX clients_name_surname_sec_index ON CLIENTS(NAME, SURNAME, SEC_SURNAME);
CREATE INDEX movies_country_duration_index ON MOVIES(COUNTRY, DURATION);
CREATE INDEX clientid_year_month ON INVOICES (CLIENTID, YEAR, MONTH);
