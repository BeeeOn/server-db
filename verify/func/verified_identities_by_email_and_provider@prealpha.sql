-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'verified_identities_by_email_and_provider(varchar(250), varchar(250))'
);

ROLLBACK;
