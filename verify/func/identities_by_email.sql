-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'identities_by_email(varchar(250))'
);

ROLLBACK;
