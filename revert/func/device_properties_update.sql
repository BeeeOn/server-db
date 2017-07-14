-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.device_properties_update(numeric, bigint, smallint, text, text);

COMMIT;
