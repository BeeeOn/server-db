-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.identities_insert(uuid, varchar(250));

COMMIT;
