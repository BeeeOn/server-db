-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.from_device_id(bigint);
DROP FUNCTION beeeon.to_device_id(bigint);
DROP FUNCTION beeeon.to_device_id(varchar);
DROP FUNCTION beeeon.to_device_id(numeric);
DROP TYPE beeeon.device;

COMMIT;
