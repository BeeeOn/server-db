-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

---
-- The table works as a materialized view of the controls_fsm
-- table and stores only the most recent transition for each
-- control.
---
CREATE TABLE beeeon.controls_fsm_last AS
WITH newset_values AS (
	SELECT
		gateway_id,
		device_id,
		module_id,
		MAX(requested_at) AS requested_at
	FROM beeeon.controls_fsm
	GROUP BY gateway_id, device_id, module_id
)
SELECT
	c.gateway_id AS gateway_id,
	c.device_id AS device_id,
	c.module_id AS module_id,
	c.value AS value,
	c.requested_at AS requested_at,
	c.accepted_at AS accepted_at,
	c.finished_at AS finished_at,
	c.failed AS failed,
	c.originator_user_id AS originator_user_id
FROM beeeon.controls_fsm AS c
JOIN newset_values AS n ON
	c.gateway_id = n.gateway_id
	AND
	c.device_id = n.device_id
	AND
	c.module_id = n.module_id
	AND
	c.requested_at = n.requested_at;

---
-- Apply constraints to the table controls_fsm_last.
---

ALTER TABLE beeeon.controls_fsm_last
	ADD CONSTRAINT controls_fsm_last_pk
	PRIMARY KEY (gateway_id, device_id, module_id);

ALTER TABLE beeeon.controls_fsm_last
	ADD CONSTRAINT controls_fsm_last_fk
	FOREIGN KEY (gateway_id, device_id, module_id, requested_at)
	REFERENCES beeeon.controls_fsm (gateway_id, device_id, module_id, requested_at);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.controls_fsm_last
	TO beeeon_user;

---
-- Logic that updates the table controls_fsm_last after insert
-- into the table controls_fsm.
---
CREATE OR REPLACE FUNCTION beeeon.controls_fsm_last_after_insert()
RETURNS TRIGGER AS
$$
DECLARE
	_requested_at timestamp;
	_finished_at timestamp;
	_value real;
	_originator_user_id uuid;
BEGIN
	SELECT
		requested_at,
		accepted_at,
		finished_at,
		value,
		originator_user_id
	INTO
		_requested_at,
		_finished_at,
		_value,
		_originator_user_id
	FROM beeeon.controls_fsm_last
	WHERE
		gateway_id = NEW.gateway_id
		AND
		device_id = NEW.device_id
		AND
		module_id = NEW.module_id;

	IF NOT FOUND THEN
		INSERT INTO beeeon.controls_fsm_last (
			gateway_id,
			device_id,
			module_id,
			value,
			requested_at,
			accepted_at,
			finished_at,
			failed,
			originator_user_id
		)
		VALUES (
			NEW.gateway_id,
			NEW.device_id,
			NEW.module_id,
			NEW.value,
			NEW.requested_at,
			NEW.accepted_at,
			NEW.finished_at,
			NEW.failed,
			NEW.originator_user_id
		);

	ELSIF _requested_at < NEW.requested_at THEN
		IF _finished_at IS NULL THEN
			RAISE EXCEPTION
				'could not begin a new request (%) while'
				' another (%) is in progress',
				NEW.requested_at, _requested_at;
		END IF;

		UPDATE beeeon.controls_fsm_last
		SET
			value = NEW.value,
			requested_at = NEW.requested_at,
			accepted_at = NEW.accepted_at,
			finished_at = NEW.finished_at,
			failed = NEW.failed,
			originator_user_id = NEW.originator_user_id
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

CREATE TRIGGER control_fsm_last_insert_trigger
AFTER INSERT ON beeeon.controls_fsm
FOR EACH ROW
	EXECUTE PROCEDURE beeeon.controls_fsm_last_after_insert();

---
-- Logic that updates the table controls_fsm_last after update
-- of the table controls_fsm.
---
CREATE OR REPLACE FUNCTION beeeon.controls_fsm_last_after_update()
RETURNS TRIGGER AS
$$
DECLARE
	_requested_at timestamp;
	_value real;
	_originator_user_id uuid;
BEGIN
	SELECT
		requested_at,
		accepted_at,
		finished_at,
		value,
		originator_user_id
	INTO
		_requested_at,
		_value,
		_originator_user_id
	FROM beeeon.controls_fsm_last
	WHERE
		gateway_id = NEW.gateway_id
		AND
		device_id = NEW.device_id
		AND
		module_id = NEW.module_id;

	-- this should happen on update
	IF FOUND AND _requested_at = NEW.requested_at THEN
		IF _value <> NEW.value THEN
			RAISE EXCEPTION
				'value cannot be changed from % to %',
				_value, NEW.value;
		END IF;

		IF _originator_user_id <> NEW.originator_user_id THEN
			RAISE EXCEPTION
				'originator cannot be changed from % to %',
				_originator_user_id, NEW.originator_user_id;
		END IF;

		UPDATE beeeon.controls_fsm_last
		SET
			accepted_at = NEW.accepted_at,
			finished_at = NEW.finished_at,
			failed = NEW.failed
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

CREATE TRIGGER control_fsm_last_update_trigger
AFTER UPDATE ON beeeon.controls_fsm
FOR EACH ROW
	EXECUTE PROCEDURE beeeon.controls_fsm_last_after_update();

COMMIT;
