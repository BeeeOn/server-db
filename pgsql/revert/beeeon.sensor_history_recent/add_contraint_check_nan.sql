-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.sensor_history_recent
	DROP CONSTRAINT check_value_not_nan;

COMMIT;
