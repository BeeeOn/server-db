-- beeeon-server, pg

BEGIN;

---
-- Return the last measured value for the given sensor. This is
-- useful to get the current state.
---
CREATE OR REPLACE FUNCTION beeeon.sensor_history_last_value (
	_gateway_id bigint,
	_device_id numeric,
	_module_id smallint
)
RETURNS TABLE (at bigint, value real) AS
$$
BEGIN
	RETURN QUERY
		SELECT
			extract(epoch FROM s.at)::bigint,
			s.value
		FROM beeeon.sensor_history_recent AS s
		WHERE
			s.gateway_id = _gateway_id
			AND
			s.device_id = beeeon.to_device_id(_device_id)
			AND
			s.module_id = _module_id
			AND
			s.at = (
				SELECT MAX(m.at) FROM beeeon.sensor_history_recent AS m
				WHERE
					m.gateway_id = _gateway_id
					AND
					m.device_id = beeeon.to_device_id(_device_id)
					AND
					m.module_id = _module_id
			)
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

---
-- Return the last measured value for sensors of the given device.
-- This is useful to gather the current states.
---
CREATE OR REPLACE FUNCTION beeeon.sensor_history_last_value (
	_gateway_id bigint,
	_device_id numeric
)
RETURNS TABLE (module_id smallint, at bigint, value real) AS
$$
BEGIN
	RETURN QUERY
		-- first find most recent at for each module
		WITH modules AS (
		SELECT
			m.gateway_id AS gateway_id,
			m.device_id AS device_id,
			m.module_id AS module_id,
			MAX(m.at) AS max_at
		FROM beeeon.sensor_history_recent AS m
		WHERE
			m.gateway_id = _gateway_id
			AND
			m.device_id = beeeon.to_device_id(_device_id)
		GROUP BY
			m.gateway_id,
			m.device_id,
			m.module_id
		)
		-- second join with the value
		SELECT
			s.module_id,
			extract(epoch FROM s.at)::bigint,
			s.value
		FROM beeeon.sensor_history_recent AS s
		JOIN modules ON
			s.gateway_id = modules.gateway_id
			AND
			s.device_id = beeeon.to_device_id(modules.device_id)
			AND
			s.module_id = modules.module_id
			AND
			s.at = modules.max_at;
END;
$$ LANGUAGE plpgsql;

COMMIT;
