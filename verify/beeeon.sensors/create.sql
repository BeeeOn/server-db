-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	refid
FROM
	beeeon.sensors
WHERE
	FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.sensors',
	ARRAY['select', 'insert', 'update', 'delete']
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init(bigint, bigint, smallint)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init_trigger()'
);

ROLLBACK;
