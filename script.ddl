-- LAB ASSIGNMENT FSDB 1

CREATE TABLE Clients
  (
    id           INTEGER NOT NULL PRIMARY KEY ,
    email        VARCHAR2 (200 CHAR) NOT NULL UNIQUE ,
    name         VARCHAR2 (50 CHAR) NOT NULL ,
    surname      VARCHAR2 (50 CHAR) NOT NULL ,
    surname2     VARCHAR2 (50 CHAR) ,
    phone_number NUMBER(9) UNIQUE , -- Ver aquí tema prefijos de países
    postal_code  INTEGER NOT NULL ,
    city         VARCHAR2 (100 CHAR) NOT NULL ,
    address      VARCHAR2 (150 CHAR) NOT NULL
  ) ;

CREATE TABLE Contracts_active
  (
    id INTEGER NOT NULL PRIMARY KEY ,
    Client_id INTEGER NOT NULL FOREIGN KEY REFERENCES Clients(id) ,
    start_date DATE NOT NULL ,
    end_date DATE ,
    contract_type INTEGER FOREIGN KEY REFERENCES Contracts_type(id) -- O mejor usar name?
  ) ;

CREATE TABLE Contracts_all -- Ambas tablas de contratos tienen que estar "sincronizadas" de alguna forma
  (
    Contracts_active_id INTEGER NOT NULL PRIMARY KEY,
    Client_id INTEGER FOREIGN KEY REFERENCES Clients(id) ,
    start_date DATE NOT NULL ,
    end_date DATE ,
    contract_type INTEGER FOREIGN KEY REFERENCES Contracts_type(id)
  ) ;

CREATE TABLE Contracts_type -- El tipo lo he declarado boolean porque solo hay PPC y PPV
  (
    id INTEGER NOT NULL PRIMARY KEY ,
    name VARCHAR2 (20 CHAR) NOT NULL UNIQUE ,
    fee INTEGER NOT NULL ,
    type BOOLEAN NOT NULL ,
    ppv NUMBER(3,2) ,
    ppc NUMBER(3,2) ,
    zapp INTEGER NOT NULL CHECK (zapp <= 100) ,
    ppm NUMBER(3,2) ,
    ppd NUMBER(3,2) ,
    promotion INTEGER NOT NULL CHECK (promotion <= 100)
  ) ;

CREATE TABLE Movies
  (
    id INTEGER NOT NULL PRIMARY KEY ,
    title VARCHAR2 (100 CHAR) NOT NULL ,
    year INTEGER NOT NULL ,
    plot_keywords ARRAY?
    duration TIME NOT NULL ,
    director_name VARCHAR2 (100 CHAR) NOT NULL ,
    genres
    language VARCHAR2 (50 CHAR) NOT NULL ,
    country VARCHAR (50 CHAR) NOT NULL ,
    budget NUMBER ,
    gross
    content_rating
    color BOOLEAN ,
    aspect_ratio
    1st_actor_name -- ARRAY O MULTISET OF ACTORS' NAME?
    2nd_actor_name
    3rd_actor_name
    facebook_likes -- ARRAY OF facebook_likes?
    director_facebook_likes
    1st_actor_facebook_likes
    2nd_actor_facebook_likes
    3rd_actor_facebook_likes
    cast_facebook_likes
    num_critics_reviews
    num_public_reviews
    num_votes
    imdb_score
    imdb_link
    facenumber
  ) ;

CREATE TABLE TVSeries
  (
    id INTEGER NOT NULL PRIMARY KEY ,
    title VARCHAR2(100 CHAR) NOT NULL ,
    seasons INTEGER ,
    episodes INTEGER ,
  ) ;
