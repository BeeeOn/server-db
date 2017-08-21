-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.legacy_roles_in_gateway_by_id(uuid);

COMMIT;
