-- beeeon-server, pg

BEGIN;

---
-- Same check as for sensor_history_recent.
---
ALTER TABLE beeeon.sensor_history_last
	ADD CONSTRAINT check_value_not_nan
	CHECK (value <> 'NaN'::real);

COMMIT;
