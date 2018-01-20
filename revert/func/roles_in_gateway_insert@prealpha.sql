-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_insert(uuid, bigint, uuid, integer, bigint);

COMMIT;
