-- beeeon-server, pg

BEGIN;

DROP TRIGGER sensors_init_before_insert
	ON beeeon.sensor_history_raw;
DROP FUNCTION beeeon.sensors_init_trigger();
DROP FUNCTION beeeon.sensors_init(
		bigint,
		bigint,
		smallint);
DROP TABLE beeeon.sensors;

COMMIT;
