-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'devices_inactive_by_gateway(bigint)'
);

ROLLBACK;
