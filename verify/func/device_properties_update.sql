-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'device_properties_update(numeric, bigint, smallint, text, text)'
);

ROLLBACK;
