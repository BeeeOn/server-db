-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'locations_update(uuid, varchar(250))'
);

ROLLBACK;
