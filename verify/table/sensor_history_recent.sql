-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	at,
	value
FROM beeeon.sensor_history_recent
WHERE
	FALSE;

ROLLBACK;
