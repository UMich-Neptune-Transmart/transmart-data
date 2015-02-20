--- Data Attestation setup ---
CREATE SEQUENCE searchapp.data_attestation_id_seq;

GRANT USAGE, SELECT, UPDATE ON searchapp.data_attestation_id_seq TO biomart_user, searchapp;

CREATE TABLE searchapp.data_attestation  ( 
    data_attestation_id	int8 NOT NULL DEFAULT nextval('searchapp.data_attestation_id_seq'::regclass),
    auth_user_id       	int8 NULL,
    last_date_agreed   	timestamp NULL 
    );

GRANT SELECT, INSERT ON searchapp.data_attestation TO biomart_user, searchapp;