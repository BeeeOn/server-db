-- beeeon-server, pg

BEGIN;

DROP TRIGGER control_fsm_last_update_trigger
	ON beeeon.controls_fsm;
DROP FUNCTION beeeon.controls_fsm_last_after_update();

DROP TRIGGER control_fsm_last_insert_trigger
	ON beeeon.controls_fsm;
DROP FUNCTION beeeon.controls_fsm_last_after_insert();

DROP TABLE beeeon.controls_fsm_last;

COMMIT;
