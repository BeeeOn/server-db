-- beeeon-server, pg

BEGIN;

---
-- Revert back the potentially buggy controls_fsm_last_after_update
-- introduced by beeeon.controls_fsm_last/create.
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

COMMIT;
