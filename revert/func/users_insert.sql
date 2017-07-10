-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.users_insert(uuid, varchar(250), varchar(250), varchar(32));

COMMIT;
