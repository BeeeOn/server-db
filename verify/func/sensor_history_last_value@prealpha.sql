-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'sensor_history_last_value(bigint, numeric, smallint)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensor_history_last_value(bigint, numeric)'
);

ROLLBACK;
