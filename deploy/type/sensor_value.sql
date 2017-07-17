-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.sensor_value AS (
	time_offset integer,
	value real
);

COMMIT;
