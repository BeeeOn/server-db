-- beeeon-server, pg

BEGIN;

SELECT id, email FROM beeeon.identities WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.identities',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
