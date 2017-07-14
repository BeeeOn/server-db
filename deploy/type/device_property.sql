-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.device_property AS (
	device_id varchar,
	gateway_id bigint,
	key smallint,
	value text,
	params text
);

COMMIT;
