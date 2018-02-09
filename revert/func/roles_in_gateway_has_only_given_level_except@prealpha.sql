-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.roles_in_gateway_has_only_given_level_except(integer, bigint, uuid);

COMMIT;
