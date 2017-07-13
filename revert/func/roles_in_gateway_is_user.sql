-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_is_user(uuid, uuid);

COMMIT;
