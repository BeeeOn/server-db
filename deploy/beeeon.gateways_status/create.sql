-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.gateways_status (
	gateway_id bigint NOT NULL,
	at timestamp NOT NULL,
	version varchar(40),
	ip inet,
	CONSTRAINT gateways_status_pk PRIMARY KEY (gateway_id, at),
	CONSTRAINT gateways_status_gateways_fk FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.gateways_status
	TO beeeon_user;

COMMIT;
