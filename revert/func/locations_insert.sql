-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.locations_insert(uuid, varchar(250), bigint);

COMMIT;
