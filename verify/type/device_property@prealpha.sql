-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'device_property'
);

ROLLBACK;
