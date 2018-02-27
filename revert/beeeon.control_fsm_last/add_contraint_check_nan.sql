-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.controls_fsm_last
	DROP CONSTRAINT check_value_not_nan;

COMMIT;
