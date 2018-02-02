-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_by_id_and_gateway(numeric, bigint);

COMMIT;
