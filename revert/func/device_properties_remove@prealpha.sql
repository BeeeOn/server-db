-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.device_properties_remove(numeric, bigint, smallint);

COMMIT;
