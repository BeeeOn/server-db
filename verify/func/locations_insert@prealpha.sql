-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'locations_insert(uuid, varchar(250), bigint)'
);

ROLLBACK;
