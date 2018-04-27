-- beeeon-server, pg

BEGIN;

---
-- Revert back to the original period initialization from change
-- beeeon.sensors/create with no influence on the NEW data.
---
CREATE OR REPLACE FUNCTION beeeon.sensors_init_trigger()
RETURNS TRIGGER AS
$$
DECLARE
	_refid integer;
BEGIN
	SELECT beeeon.sensors_init(
		NEW.gateway_id,
		NEW.device_id,
		NEW.module_id
	) INTO _refid;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE beeeon.sensor_history_raw
	DROP CONSTRAINT sensor_history_raw_sensors_fk;

ALTER TABLE beeeon.sensor_history_raw
	DROP COLUMN refid;

COMMIT;
