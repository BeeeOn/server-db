-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.controls_recent_state(bigint, numeric, smallint);

COMMIT;
