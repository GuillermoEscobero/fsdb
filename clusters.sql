CREATE CLUSTER movie_cluster(movie_title VARCHAR2(100 CHAR));
CREATE CLUSTER client_cluster(clientid VARCHAR2(15 CHAR));
CREATE CLUSTER contract_cluster(contractid VARCHAR2(10 CHAR));

CREATE INDEX index_movie ON CLUSTER movie_cluster;
CREATE INDEX index_client ON CLUSTER client_cluster;
CREATE INDEX index_contract ON CLUSTER contract_cluster;
