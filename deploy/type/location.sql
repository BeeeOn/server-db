-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.location AS (
	id uuid,
	name varchar(250),
	gateway_id bigint
);

COMMIT;
