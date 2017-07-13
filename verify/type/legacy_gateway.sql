-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'legacy_gateway'
);

ROLLBACK;
