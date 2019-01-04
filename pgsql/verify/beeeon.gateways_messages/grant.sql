-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.gateways_messages',
	ARRAY['select', 'insert', 'update', 'delete']
);

ROLLBACK;
