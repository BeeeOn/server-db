-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_accessible_gateways(integer, uuid);

COMMIT;
