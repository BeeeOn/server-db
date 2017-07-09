-- beeeon-server, pg

BEGIN;

SELECT id, gateway_id, identity_id, level, created
	FROM beeeon.roles_in_gateway WHERE FALSE;

ROLLBACK;
