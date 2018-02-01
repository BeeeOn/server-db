-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'legacy_gateways_accessible(uuid)'
);

ROLLBACK;
