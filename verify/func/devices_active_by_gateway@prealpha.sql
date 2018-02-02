-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'devices_active_by_gateway(bigint)'
);

ROLLBACK;
