-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'identities_by_id(uuid)'
);

ROLLBACK;
