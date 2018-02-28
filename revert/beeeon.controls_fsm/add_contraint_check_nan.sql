-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.controls_fsm
	DROP CONSTRAINT check_value_not_nan;

COMMIT;
