-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'identities_remove(uuid)'
);

ROLLBACK;
