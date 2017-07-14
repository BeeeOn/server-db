-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'device_properties_insert(numeric, bigint, smallint, text, text)'
);

ROLLBACK;
