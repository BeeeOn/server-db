-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'align_timestamp(timestamp, integer)'
);

ROLLBACK;
