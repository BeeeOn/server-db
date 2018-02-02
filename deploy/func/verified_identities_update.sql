-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_update(uuid, varchar, varchar);

COMMIT;
