-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'fcm_token'
);

ROLLBACK;
