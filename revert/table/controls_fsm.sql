-- beeeon-server, pg

BEGIN;


DROP TRIGGER control_fsm_last_update_trigger
	ON beeeon.controls_fsm;
DROP TRIGGER control_fsm_last_insert_trigger
	ON beeeon.controls_fsm;
DROP FUNCTION beeeon.controls_fsm_last_update();
DROP TABLE beeeon.controls_fsm_last;
DROP TABLE beeeon.controls_fsm;

COMMIT;
