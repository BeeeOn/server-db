-- beeeon-server, pg

BEGIN;

CREATE VIEW beeeon.sensor_history AS
	SELECT
		s.gateway_id AS gateway_id,
		s.device_id AS device_id,
		s.module_id AS module_id,
		r.at AS at,
		r.value AS value
	FROM
		beeeon.sensor_history_raw AS r
	JOIN
		beeeon.sensors AS s
	ON
		r.refid = s.refid;

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.sensor_history
	TO beeeon_user;

---
-- Remove the trigger performing refid extension.
---
DROP TRIGGER sensors_init_before_insert
	ON beeeon.sensor_history_raw;
DROP FUNCTION beeeon.sensors_init_trigger();

---
-- Mimic inserting into the sensor_history that is view. The insert
-- means to potentially update sensors, insert into sensor_history_raw
-- and update the materialized view sensor_history_last.
---
CREATE OR REPLACE FUNCTION beeeon.insert_into_sensor_history(NEW beeeon.sensor_history)
RETURNS VOID AS
$$
DECLARE
	_pstart timestamp;
	_refid integer;
BEGIN
	SELECT beeeon.sensors_init(
		NEW.gateway_id,
		NEW.device_id,
		NEW.module_id
	) INTO _refid;

	INSERT INTO beeeon.sensor_history_raw (
		gateway_id,
		device_id,
		module_id,
		refid,
		at,
		value
	)
	VALUES (
		NEW.gateway_id,
		NEW.device_id,
		NEW.module_id,
		_refid,
		NEW.at,
		NEW.value
	);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE RULE insert_rule AS
ON INSERT TO beeeon.sensor_history
DO INSTEAD
	SELECT beeeon.insert_into_sensor_history(NEW);

COMMIT;
