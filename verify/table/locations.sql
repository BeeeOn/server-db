-- beeeon-server, pg

BEGIN;

SELECT id, name, gateway_id
	FROM beeeon.locations WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.locations',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
