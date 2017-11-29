-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'fcm_recipients_by_gateway(BIGINT)'
);

ROLLBACK;
