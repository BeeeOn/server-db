-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'fcm_tokens_by_user_id(uuid)'
);

ROLLBACK;
