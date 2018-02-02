-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_by_id(uuid);

COMMIT;
