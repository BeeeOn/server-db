-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.sensor_history_recent_insert(bigint, bigint, smallint, timestamp with time zone, real);

COMMIT;
