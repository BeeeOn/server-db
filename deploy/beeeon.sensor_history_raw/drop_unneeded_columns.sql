-- beeeon-server, pg

BEGIN;

---
-- Remove constraints related to gateway_id, device_id and module_id.
---
ALTER TABLE beeeon.sensor_history_raw
	DROP CONSTRAINT sensor_history_raw_device_fk,
	DROP CONSTRAINT sensor_history_raw_gateway_fk,
	DROP CONSTRAINT sensor_history_raw_pk;

---
-- Materialized view sensor_history_last must be updated upon inserting
-- into sensor_history that contains gateway_id, device_id, and module_id.
-- This is now accomplished by rule insert_into_sensor_history.
---
DROP TRIGGER sensor_history_last_update_trigger ON beeeon.sensor_history_raw;
DROP FUNCTION beeeon.sensor_history_last_update();

---
-- The function from sensor_history_last/create is not a trigger
-- anymore. It accepts the NEW field as it argument to be callable
-- from non-trigger context.
---
CREATE FUNCTION beeeon.sensor_history_last_update(NEW beeeon.sensor_history)
RETURNS VOID AS
$$
DECLARE
	_at timestamp;
BEGIN
	SELECT at INTO _at FROM beeeon.sensor_history_last
	WHERE
		gateway_id = NEW.gateway_id
		AND
		device_id = NEW.device_id
		AND
		module_id = NEW.module_id;

	IF NOT FOUND THEN
		INSERT INTO beeeon.sensor_history_last (
			gateway_id,
			device_id,
			module_id,
			at,
			value
		)
		VALUES (
			NEW.gateway_id,
			NEW.device_id,
			NEW.module_id,
			NEW.at,
			NEW.value
		);
	ELSIF _at < NEW.at THEN
		UPDATE beeeon.sensor_history_last
		SET
			at = NEW.at,
			value = NEW.value
		WHERE
			gateway_id = NEW.gateway_id
			AND
			device_id = NEW.device_id
			AND
			module_id = NEW.module_id;
	END IF;
END;
$$ LANGUAGE plpgsql;

---
-- The function insert_into_sensor_history is changed to
-- not insert gateway_id, device_id and module_id into
-- the table sensor_history_raw.
--
-- Also, update the sensor_history_last materialized view
-- from here.
---
CREATE OR REPLACE FUNCTION beeeon.insert_into_sensor_history(
		NEW beeeon.sensor_history)
RETURNS VOID AS
$$
DECLARE
	_pstart timestamp;
	_refid integer;
BEGIN
	SELECT refid INTO _refid
	FROM
		beeeon.sensors
	WHERE
		gateway_id = NEW.gateway_id
		AND
		device_id = NEW.device_id
		AND
		module_id = NEW.module_id;

	IF NOT FOUND THEN
		INSERT INTO beeeon.sensors (
			gateway_id,
			device_id,
			module_id
		)
		VALUES (
			NEW.gateway_id,
			NEW.device_id,
			NEW.module_id
		)
		RETURNING refid INTO _refid;
	END IF;

	INSERT INTO beeeon.sensor_history_raw (
		refid,
		at,
		value
	)
	VALUES (
		_refid,
		NEW.at,
		NEW.value
	);

	PERFORM beeeon.sensor_history_last_update(NEW);
END;
$$ LANGUAGE plpgsql;

---
-- Columns gateway_id, device_id and module_id are not used anymore.
-- Drop them.
---
ALTER TABLE beeeon.sensor_history_raw
	DROP COLUMN gateway_id,
	DROP COLUMN device_id,
	DROP COLUMN module_id;

---
-- We have new primary key using refid.
-- It is a good idea to run CLUSTER of the table by this key.
---
ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT sensor_history_raw_pk PRIMARY KEY (refid, at);

COMMIT;
