-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_remove_user(uuid, bigint);

COMMIT;
