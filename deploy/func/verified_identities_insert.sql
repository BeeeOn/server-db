-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_insert(uuid, uuid, uuid, varchar, varchar, varchar);

COMMIT;
