-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'control_recent'
);

ROLLBACK;
