-- beeeon-server, pg

BEGIN;

---
-- Revert back the potentially buggy controls_fsm_last_after_insert
-- introduced by beeeon.controls_fsm_last/create.
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


COMMIT;
