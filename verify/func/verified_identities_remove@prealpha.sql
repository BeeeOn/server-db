-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'verified_identities_remove(uuid)'
);

ROLLBACK;
