-- beeeon-server pg

BEGIN;

DROP FUNCTION beeeon.verified_identities_by_email_and_provider(
	varchar(250),
	varchar(250)
);

COMMIT;
