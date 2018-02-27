-- beeeon-server, pg

BEGIN;

---
-- Same check as for controls_fsm.
---
ALTER TABLE beeeon.controls_fsm_last
	ADD CONSTRAINT check_value_not_nan
	CHECK (value <> 'NaN'::real);

COMMIT;
