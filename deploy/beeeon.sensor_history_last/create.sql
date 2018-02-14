-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

---
-- This table works as a materialized view of the sensor_history_recent
-- table and stores only the most recent values (last values) for each
-- sensor.
---
CREATE TABLE beeeon.sensor_history_last AS
WITH newest_values AS (
	SELECT
		gateway_id,
		device_id,
		module_id,
		MAX(at) AS at
	FROM beeeon.sensor_history_recent
	GROUP BY gateway_id, device_id, module_id
)
SELECT
	r.gateway_id AS gateway_id,
	r.device_id AS device_id,
	r.module_id AS module_id,
	r.at AS at,
	r.value AS value
FROM beeeon.sensor_history_recent AS r
JOIN newest_values AS n ON
	r.gateway_id = n.gateway_id
	AND
	r.device_id = n.device_id
	AND
	r.module_id = n.module_id
	AND
	r.at = n.at;

---
-- Apply constraints to the table sensor_history_last.
---

ALTER TABLE beeeon.sensor_history_last
	ADD CONSTRAINT sensor_history_last_pk
	PRIMARY KEY (gateway_id, device_id, module_id);

ALTER TABLE beeeon.sensor_history_last
	ADD CONSTRAINT sensor_history_last_gateway_fk
	FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id);

ALTER TABLE beeeon.sensor_history_last
	ADD CONSTRAINT sensor_history_last_device_fk
	FOREIGN KEY (gateway_id, device_id)
	REFERENCES beeeon.devices (gateway_id, id);

ALTER TABLE beeeon.sensor_history_last
	ALTER COLUMN gateway_id SET NOT NULL;
ALTER TABLE beeeon.sensor_history_last
	ALTER COLUMN device_id SET NOT NULL;
ALTER TABLE beeeon.sensor_history_last
	ALTER COLUMN module_id SET NOT NULL;
ALTER TABLE beeeon.sensor_history_last
	ALTER COLUMN at SET NOT NULL;

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.sensor_history_last
	TO beeeon_user;

---
-- Function that updates the table sensor_history_last based on
-- an insertion into the table sensor_history_recent. If the
-- newly inserted value has a newer timestamp, it is placed
-- also into the table sensor_history_last.
---
CREATE OR REPLACE FUNCTION beeeon.sensor_history_last_update()
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
AFTER INSERT ON beeeon.sensor_history_recent
FOR EACH ROW
	EXECUTE PROCEDURE beeeon.sensor_history_last_update();


COMMIT;
