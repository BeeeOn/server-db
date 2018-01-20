-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'fcm_tokens_insert(varchar(250), uuid)'
);

ROLLBACK;
