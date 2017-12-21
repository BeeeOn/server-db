-- beeeon-server, pg

BEGIN;

DROP TRIGGER sensor_history_last_update_trigger
	ON beeeon.sensor_history_recent;
DROP FUNCTION beeeon.sensor_history_last_update();
DROP TABLE beeeon.sensor_history_last;

COMMIT;
