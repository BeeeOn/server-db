-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'locations_by_id_and_gateway(uuid, bigint)'
);

ROLLBACK;
