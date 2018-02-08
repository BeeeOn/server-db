-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_access_level(bigint, uuid);

COMMIT;
