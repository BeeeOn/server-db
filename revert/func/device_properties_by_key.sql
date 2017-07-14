-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.device_properties_by_key(numeric, bigint, smallint);

COMMIT;
