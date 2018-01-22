-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.controls_recent_state(bigint, numeric(20, 0), smallint);

COMMIT;
