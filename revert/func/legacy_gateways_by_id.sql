-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.legacy_gateways_by_id(uuid, bigint);

COMMIT;
