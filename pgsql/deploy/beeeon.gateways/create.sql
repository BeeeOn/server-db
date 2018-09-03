-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.gateways (
	id bigint NOT NULL,
	name varchar(250) NOT NULL,
	altitude integer,
	latitude double precision,
	longitude double precision,
	timezone varchar(64) NOT NULL DEFAULT 'GMT',
	CONSTRAINT gateways_pk PRIMARY KEY (id)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.gateways
	TO beeeon_user;

COMMIT;
