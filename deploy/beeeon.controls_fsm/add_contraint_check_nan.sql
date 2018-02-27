-- beeeon-server, pg

BEGIN;

---
-- Make sure the inserted values are never NaN which does
-- not make sense when setting a controllable module.
---
ALTER TABLE beeeon.controls_fsm
	ADD CONSTRAINT check_value_not_nan
	CHECK (value <> 'NaN'::real);

COMMIT;
