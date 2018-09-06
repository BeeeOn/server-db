-- beeeon-server, pg

BEGIN;

SELECT id, gateway_id, identity_id, level, created
	FROM beeeon.roles_in_gateway WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.roles_in_gateway',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
