-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_accessible(uuid)'
);

ROLLBACK;
