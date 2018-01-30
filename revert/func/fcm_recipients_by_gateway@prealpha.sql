-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.fcm_recipients_by_gateway(BIGINT);

COMMIT;
