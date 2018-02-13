-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'location'
);

ROLLBACK;
