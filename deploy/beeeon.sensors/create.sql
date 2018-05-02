-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

---
-- Generate sensors for each sensor in sensor_history_raw.
-- Each sensor has its refid (surrogate key) that would be
-- used for cheap referencing from very huge tables.
---
CREATE TABLE beeeon.sensors AS
SELECT
	r.gateway_id AS gateway_id,
	r.device_id AS device_id,
	r.module_id AS module_id
FROM
	beeeon.sensor_history_raw AS r
GROUP BY
	r.gateway_id,
	r.device_id,
	r.module_id;

ALTER TABLE beeeon.sensors
	ALTER COLUMN gateway_id SET NOT NULL,
	ALTER COLUMN device_id SET NOT NULL,
	ALTER COLUMN module_id SET NOT NULL,
	ADD COLUMN refid serial NOT NULL;

---
-- Create natural constraints of the table:
--
-- * PK - gateway_id, device_id, module_id
-- * FK - linking us with devices
-- * UNIQUE - refid must be unique
---
ALTER TABLE beeeon.sensors
	ADD CONSTRAINT sensors_pk
	PRIMARY KEY (gateway_id, device_id, module_id);

ALTER TABLE beeeon.sensors
	ADD CONSTRAINT sensors_devices_fk
	FOREIGN KEY (gateway_id, device_id)
		REFERENCES beeeon.devices (gateway_id, id);

ALTER TABLE beeeon.sensors
	ADD CONSTRAINT refid_unique
	UNIQUE (refid);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.sensors
	TO beeeon_user;

GRANT USAGE, SELECT
	ON SEQUENCE beeeon.sensors_refid_seq
	TO beeeon_user;

---
-- Initialize a single record in the sensors table
-- if no such exists yet - generic function.
---
CREATE OR REPLACE FUNCTION beeeon.sensors_init(
	_gateway_id bigint,
	_device_id bigint,
	_module_id smallint)
RETURNS integer AS
$$
DECLARE
	_refid integer := 0;
BEGIN
	SELECT
		refid
	INTO
		_refid
	FROM
		beeeon.sensors
	WHERE
		gateway_id = _gateway_id
		AND
		device_id = _device_id
		AND
		module_id = _module_id
	LIMIT 1;

	IF NOT FOUND THEN
		INSERT INTO beeeon.sensors (
			gateway_id,
			device_id,
			module_id
		)
		VALUES (
			_gateway_id,
			_device_id,
			_module_id
		)
		RETURNING refid INTO _refid;
	END IF;

	RETURN _refid;
END;
$$ LANGUAGE plpgsql;

---
-- Trigger function to init non-existing sensors. It is going
-- to be changed by future modifications.
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

CREATE TRIGGER sensors_init_before_insert
	BEFORE INSERT
	ON beeeon.sensor_history_raw
	FOR EACH ROW EXECUTE
		PROCEDURE beeeon.sensors_init_trigger();

COMMIT;
