-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.gateway_with_status AS (
	id bigint,
	name varchar(250),
	altitude integer,
	latitude double precision,
	longitude double precision,
	timezone varchar(64),
	last_changed bigint,
	version varchar(40),
	ip varchar(45)
);

COMMIT;
