-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'legacy_gateways_by_id(uuid, bigint)'
);

ROLLBACK;
