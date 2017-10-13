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

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.sensor_history_recent',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
