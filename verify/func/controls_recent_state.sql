-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'controls_recent_state(bigint, numeric, smallint)'
);

ROLLBACK;
