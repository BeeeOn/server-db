-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.identities_by_email(varchar(250));

COMMIT;
