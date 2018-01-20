-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.fcm_tokens_insert(varchar(250), uuid);

COMMIT;
