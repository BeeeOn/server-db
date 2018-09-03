-- beeeon-server, pg

BEGIN;

---
-- Avoid NaN value in database. Use NULL instead. NULL is easier to
-- handle (IS NULL, IS NOT NULL) in queries and it is quite a natural
-- representation.
--
-- The original NaN semantics are "unknown value of sensor" like "broken"
-- or "disconnected", "inactive", etc.
---
ALTER TABLE beeeon.sensor_history_recent
	ADD CONSTRAINT check_value_not_nan
	CHECK (value <> 'NaN'::real);

COMMIT;
