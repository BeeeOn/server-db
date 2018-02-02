-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_by_email(varchar(250));

COMMIT;
