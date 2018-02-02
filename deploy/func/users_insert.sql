-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.users_insert(uuid, varchar, varchar, varchar);

COMMIT;
