-- beeeon-server, pg

BEGIN;

---
-- Add refid column to sensor_history_raw.
---
ALTER TABLE beeeon.sensor_history_raw
	ADD COLUMN refid integer;

---
-- Fill the refid column by values from sensors.
-- It is supposed that the sensors already exist.
---
UPDATE
	beeeon.sensor_history_raw AS r
SET
	refid = (
		SELECT
			s.refid
		FROM
			beeeon.sensors AS s
		WHERE
			s.gateway_id = r.gateway_id
			AND
			s.device_id = r.device_id
			AND
			s.module_id = r.module_id
	);

---
-- Post-fix refid column's constraints and properties.
---
ALTER TABLE beeeon.sensor_history_raw
	ALTER COLUMN refid SET NOT NULL;

ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT sensor_history_raw_sensors_fk
		FOREIGN KEY (refid)
		REFERENCES beeeon.sensors (refid);

---
-- Replace the original sensors trigger to set the refid
-- for table sensor_history_raw.
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

	NEW.refid = _refid;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMIT;
