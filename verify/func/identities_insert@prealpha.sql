-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'identities_insert(uuid, varchar(250))'
);

ROLLBACK;
