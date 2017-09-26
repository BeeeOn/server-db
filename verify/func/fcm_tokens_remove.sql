-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'fcm_tokens_remove(varchar(250))'
);

ROLLBACK;
