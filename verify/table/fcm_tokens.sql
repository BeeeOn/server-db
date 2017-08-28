-- beeeon-server, pg

BEGIN;

SELECT
	token,
	user_id
FROM beeeon.fcm_tokens
WHERE FALSE;

ROLLBACK;
