-- beeeon-server, pg

BEGIN;

SELECT gateway_id, role_id, identity_id, created, level, user_id
	FROM beeeon.users_of_gateway WHERE FALSE;

ROLLBACK;
