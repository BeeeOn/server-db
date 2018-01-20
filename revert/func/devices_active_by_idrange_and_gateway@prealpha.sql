-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_active_by_idrange_and_gateway(bigint, numeric, numeric);

COMMIT;
