-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_update(uuid, varchar(250), varchar(250));

COMMIT;
