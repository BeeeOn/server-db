-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'verified_identities_insert(uuid, uuid, uuid, varchar(250), varchar(250), varchar(250))'
);

ROLLBACK;
