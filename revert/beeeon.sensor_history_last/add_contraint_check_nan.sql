-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.sensor_history_last
	DROP CONSTRAINT check_value_not_nan;

COMMIT;
