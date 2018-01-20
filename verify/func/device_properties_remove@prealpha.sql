-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'device_properties_remove(numeric, bigint, smallint)'
);

ROLLBACK;
