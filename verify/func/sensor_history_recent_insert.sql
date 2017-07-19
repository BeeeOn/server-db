-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'sensor_history_recent_insert(bigint, bigint, smallint, timestamp with time zone, real)'
);

ROLLBACK;
