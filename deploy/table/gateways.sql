-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.gateways (
	id bigint NOT NULL,
	name varchar(250) NOT NULL,
	altitude integer DEFAULT NULL,
	latitude double precision DEFAULT NULL,
	longitude double precision DEFAULT NULL,
	CONSTRAINT gateways_pk PRIMARY KEY (id)
);

COMMIT;
