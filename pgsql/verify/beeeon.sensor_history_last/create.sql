-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	at,
	value
FROM beeeon.sensor_history_last
WHERE
	FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.sensor_history_last',
	ARRAY['select', 'insert', 'update', 'delete']
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensor_history_last_update()'
);

ROLLBACK;
