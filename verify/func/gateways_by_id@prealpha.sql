-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_by_id(bigint)'
);

ROLLBACK;
