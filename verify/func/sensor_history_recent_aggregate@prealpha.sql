-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'sensor_history_recent_aggregate(bigint, numeric, smallint, bigint, bigint, bigint)'
);

ROLLBACK;
