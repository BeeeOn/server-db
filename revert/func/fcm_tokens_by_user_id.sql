-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.fcm_tokens_by_user_id(uuid);

COMMIT;
