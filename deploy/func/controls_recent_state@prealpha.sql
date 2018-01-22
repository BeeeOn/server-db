-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.controls_recent_state(
	_gateway_id bigint,
	_device_id numeric(20, 0),
	_module_id smallint
)
RETURNS SETOF beeeon.control_recent AS
$$
BEGIN
	RETURN QUERY
	WITH
	current_state AS (
		SELECT
			value,
			at,
			stability,
			originator_user_id
		FROM beeeon.controls_recent
			WHERE
				gateway_id = _gateway_id
				AND
				device_id = beeeon.to_device_id(_device_id)
				AND
				module_id = _module_id
			ORDER BY at DESC
			LIMIT 1
	),
	confirmed_state AS (
		SELECT
			value,
			at,
			stability,
			originator_user_id
		FROM beeeon.controls_recent
			WHERE
				gateway_id = _gateway_id
				AND
				device_id = beeeon.to_device_id(_device_id)
				AND
				module_id = _module_id
				AND
				beeeon.control_stability_is_confirmed(stability)
			ORDER BY at DESC
			LIMIT 1
	)
	SELECT
		_gateway_id,
		_device_id::numeric(20, 0),
		_module_id,
		extract(epoch FROM confirmed_state.at)::bigint,
		confirmed_state.value,
		beeeon.from_control_stability(confirmed_state.stability),
		confirmed_state.originator_user_id,
		extract(epoch FROM current_state.at)::bigint,
		current_state.value,
		beeeon.from_control_stability(current_state.stability),
		current_state.originator_user_id
	FROM current_state
	LEFT JOIN confirmed_state ON TRUE
	LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
