-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.sensor_history_last_value (bigint, numeric, smallint);
DROP FUNCTION beeeon.sensor_history_last_value (bigint, numeric);

COMMIT;
