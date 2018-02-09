-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.sensor_history_recent_aggregate(bigint, numeric, smallint, bigint, bigint, bigint);

COMMIT;
