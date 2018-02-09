-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.device_properties_insert(numeric, bigint, smallint, text, text);

COMMIT;
