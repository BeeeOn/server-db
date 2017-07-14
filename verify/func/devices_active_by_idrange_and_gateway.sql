-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'devices_active_by_idrange_and_gateway(bigint, numeric, numeric)'
);

ROLLBACK;
