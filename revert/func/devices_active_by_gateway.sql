-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_active_by_gateway(bigint);

COMMIT;
