-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'now_utc()'
);

ROLLBACK;
