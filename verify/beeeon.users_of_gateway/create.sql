-- beeeon-server, pg

BEGIN;

SELECT gateway_id, role_id, identity_id, created, level, user_id
	FROM beeeon.users_of_gateway WHERE FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.users_of_gateway',
	ARRAY['select']
);

ROLLBACK;
