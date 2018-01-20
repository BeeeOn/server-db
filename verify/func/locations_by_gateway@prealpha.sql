-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'locations_by_gateway(bigint)'
);

ROLLBACK;
