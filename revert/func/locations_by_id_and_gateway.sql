-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.locations_by_id_and_gateway(uuid, bigint);

COMMIT;
