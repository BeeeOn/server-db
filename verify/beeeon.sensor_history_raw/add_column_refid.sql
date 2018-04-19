-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	refid,
	at,
	value
FROM
	beeeon.sensor_history_raw
WHERE
	FALSE;

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init(bigint, bigint, smallint)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init_trigger()'
);

ROLLBACK;
