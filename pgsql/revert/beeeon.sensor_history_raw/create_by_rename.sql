-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.sensor_history_raw
	RENAME CONSTRAINT sensor_history_raw_gateway_fk
	TO sensor_history_recent_gateway_fk;

ALTER TABLE beeeon.sensor_history_raw
	RENAME CONSTRAINT sensor_history_raw_device_fk
	TO sensor_history_recent_device_fk;

ALTER INDEX beeeon.sensor_history_raw_pk
	RENAME TO sensor_history_recent_pk;

ALTER TABLE beeeon.sensor_history_raw
	RENAME TO sensor_history_recent;

COMMIT;
