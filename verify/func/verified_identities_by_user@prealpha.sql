-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'verified_identities_by_user(uuid)'
);

ROLLBACK;
