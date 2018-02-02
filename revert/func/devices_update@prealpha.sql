-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_update(numeric(20, 0), bigint, uuid, varchar(250), smallint, integer, smallint, smallint, bigint);

COMMIT;
