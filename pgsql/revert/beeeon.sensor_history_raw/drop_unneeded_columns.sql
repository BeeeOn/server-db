-- beeeon-server, pg

BEGIN;

---
-- Get rid of the refid PK. Soon, we will revert to the original
-- PK without refid.
---
ALTER TABLE beeeon.sensor_history_raw
	DROP CONSTRAINT sensor_history_raw_pk;

---
-- Return back to the original columns in the same order.
-- We have to fix at2 and value2 later.
---
ALTER TABLE beeeon.sensor_history_raw
	ADD COLUMN module_id smallint,
	ADD COLUMN device_id bigint,
	ADD COLUMN gateway_id bigint,
	ADD COLUMN at2 timestamp,
	ADD COLUMN value2 real;

UPDATE beeeon.sensor_history_raw AS r
SET
	(gateway_id, device_id,	module_id) = (
		SELECT
			s.gateway_id,
			s.device_id,
			s.module_id
		FROM
			beeeon.sensors AS s
		WHERE
			s.refid = r.refid
	),
	at2 = at,
	value2 = value;

---
-- Drop at and value columns which are misordered.
-- Drop also depending objects, they are to be recreated
-- afterwards:
--
-- * view beeeon.sensor_history
-- * function beeeon.sensor_history_last_update(beeeon.sensor_history)
-- * function beeeon.insert_into_sensor_history(beeeon.sensor_history)
-- * constraint check_value_not_nan
---
SET client_min_messages = 'warning';

ALTER TABLE beeeon.sensor_history_raw
	DROP COLUMN at CASCADE,
	DROP COLUMN value CASCADE;

SET client_min_messages = 'notice';

---
-- Fix names of at2 and value2 to their original names and settings.
-- Now, we are the original sensor_history_raw table. No data loss
-- possible here, we have copied at and value already.
---
ALTER TABLE beeeon.sensor_history_raw
	RENAME COLUMN at2 TO at;

ALTER TABLE beeeon.sensor_history_raw
	RENAME COLUMN value2 TO value;

ALTER TABLE beeeon.sensor_history_raw
	ALTER COLUMN at SET NOT NULL;

---
-- Fix constraints of gateway_id, device_id, module_id.
---
ALTER TABLE beeeon.sensor_history_raw
	ALTER COLUMN module_id SET NOT NULL,
	ALTER COLUMN device_id SET NOT NULL,
	ALTER COLUMN gateway_id SET NOT NULL;

---
-- Recreate constraint check_value_not_nan dropped with value column.
---
ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT check_value_not_nan
	CHECK (value <> 'NaN'::real);

---
-- Recreate the sensor_history view dropped with at and value columns.
---
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
-- Recreate the previous implementation that inserts gateway_id,
-- device_id and module_id into the sensor_history_raw table.
---
CREATE FUNCTION beeeon.insert_into_sensor_history(
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

---
-- Recreate the rule for inserting via sensor_history view
-- that was dropped while fixing at and value.
---
CREATE RULE insert_rule AS
ON INSERT TO beeeon.sensor_history
DO INSTEAD
	SELECT beeeon.insert_into_sensor_history(NEW);

---
-- Recreate to filling the materialized view sensor_history_last
-- from inserts into sensor_history_raw again.
---
CREATE FUNCTION beeeon.sensor_history_last_update()
RETURNS TRIGGER AS
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

	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sensor_history_last_update_trigger
AFTER INSERT ON beeeon.sensor_history_raw
FOR EACH ROW
	EXECUTE PROCEDURE beeeon.sensor_history_last_update();

---
-- Create the original constraints and PK again based on
-- gateway_id, device_id and module_id. It is a good idea
-- to call CLUSTER on the table.
---
ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT sensor_history_raw_pk
	PRIMARY KEY (gateway_id, device_id, module_id, at);

ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT sensor_history_raw_gateway_fk
	FOREIGN KEY (gateway_id)
	REFERENCES beeeon.gateways(id);

ALTER TABLE beeeon.sensor_history_raw
	ADD CONSTRAINT sensor_history_raw_device_fk
	FOREIGN KEY (gateway_id, device_id)
	REFERENCES beeeon.devices(gateway_id, id);

COMMIT;
