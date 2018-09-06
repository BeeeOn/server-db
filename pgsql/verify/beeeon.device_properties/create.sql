-- beeeon-server, pg

BEGIN;

SELECT device_id, gateway_id, key, value, params
	FROM beeeon.device_properties WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.device_properties',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
