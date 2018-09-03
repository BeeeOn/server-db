-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_status_most_recent(bigint)'
);

ROLLBACK;
