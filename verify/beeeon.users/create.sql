-- beeeon-server, pg

BEGIN;

SELECT id, first_name, last_name
	FROM beeeon.users WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.users',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
