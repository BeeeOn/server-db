-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'device_properties_by_device(numeric, bigint)'
);

ROLLBACK;
