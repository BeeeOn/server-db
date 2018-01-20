-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'locations_remove(uuid)'
);

ROLLBACK;
