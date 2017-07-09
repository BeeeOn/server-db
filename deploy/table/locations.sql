-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.locations (
	id uuid NOT NULL,
	name varchar(250) NOT NULL,
	gateway_id bigint,
	CONSTRAINT locations_pk PRIMARY KEY (id),
	CONSTRAINT locations_gateways_fk FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id)
);

COMMIT;
