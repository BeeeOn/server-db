WITH
input AS (
	SELECT
		$1::bigint AS gateway_id,
		$2::numeric(20, 0) AS device_id,
		$3::smallint AS module_id,
		beeeon.as_utc_timestamp($4::bigint) AS start_ts,
		beeeon.as_utc_timestamp($5::bigint) AS end_ts,
		$6::bigint AS secs_interval
)
SELECT
	extract(epoch FROM
		s.at - interval '1 second' * (
			(60 * date_part('minute', s.at)::bigint
				+ date_part('second', s.at)::bigint)
			% input.secs_interval)
	)::bigint AS at,
	AVG(s.value)::real AS avg,
	MIN(s.value)::real AS min,
	MAX(s.value)::real AS max
FROM
	beeeon.sensor_history_recent AS s,
	input
WHERE
	s.gateway_id = input.gateway_id
	AND
	s.device_id = beeeon.to_device_id(input.device_id)
	AND
	s.module_id = input.module_id
	AND
	input.start_ts <= s.at
	AND
	s.at < input.end_ts
	AND
	s.value IS NOT NULL
GROUP BY 1
ORDER BY 1
