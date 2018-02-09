-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_can_see_verified_identity(uuid, uuid);

COMMIT;
