-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.sensor_history_recent_aggregate (
	_gateway_id bigint,
	_device_id numeric,
	_module_id smallint,
	_start bigint,
	_end bigint,
	_interval bigint
)
RETURNS TABLE (
	at bigint,
	avg real,
	min real,
	max real
) AS
$$
DECLARE
	_start_ts timestamp;
	_end_ts timestamp;
BEGIN
	_start_ts = beeeon.as_utc_timestamp(_start);
	_end_ts = beeeon.as_utc_timestamp(_end);

	IF _interval <= 5 THEN
		-- return all without aggregation (huh!)
		RETURN QUERY
		SELECT
			extract(epoch FROM s.at)::bigint,
			s.value,
			s.value,
			s.value
		FROM beeeon.sensor_history_recent AS s
		WHERE
			s.gateway_id = _gateway_id
			AND
			s.device_id = beeeon.to_device_id(_device_id)
			AND
			s.module_id = _module_id
			AND
			_start_ts <= s.at
			AND
			s.at < _end_ts
		ORDER BY s.at;
	ELSE
		RETURN QUERY
		SELECT
			extract(epoch FROM s.at - interval '1 second'
				* ((60 * date_part('minute', s.at)::bigint
					+ date_part('second', s.at)::bigint
				  ) % _interval))::bigint,
			AVG(s.value)::real,
			MIN(s.value)::real,
			MAX(s.value)::real
		FROM beeeon.sensor_history_recent AS s
		WHERE
			s.gateway_id = _gateway_id
			AND
			s.device_id = beeeon.to_device_id(_device_id)
			AND
			s.module_id = _module_id
			AND
			_start_ts <= s.at
			AND
			s.at < _end_ts
			AND
			s.value IS NOT NULL
		GROUP BY 1
		ORDER BY 1;
	END IF;
END;
$$ LANGUAGE plpgsql;

COMMIT;
