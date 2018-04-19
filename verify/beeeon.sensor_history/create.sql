-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	at,
	value
FROM
	beeeon.sensor_history
WHERE
	FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.sensor_history',
	ARRAY['select', 'insert', 'update', 'delete']
);

SELECT beeeon.assure_function(
	'beeeon',
	'insert_into_sensor_history(beeeon.sensor_history)'
);

ROLLBACK;
