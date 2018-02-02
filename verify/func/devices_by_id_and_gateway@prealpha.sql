-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'devices_by_id_and_gateway(numeric(20, 0), bigint)'
);

ROLLBACK;
