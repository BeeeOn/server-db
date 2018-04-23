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
		r.at - interval '1 second' * (
			(60 * date_part('minute', r.at)::bigint
				+ date_part('second', r.at)::bigint)
			% input.secs_interval)
	)::bigint AS at,
	AVG(r.value)::real AS avg,
	MIN(r.value)::real AS min,
	MAX(r.value)::real AS max
FROM
	beeeon.sensor_history_raw AS r,
	input
WHERE
	r.refid = (SELECT refid
		FROM beeeon.sensors
		WHERE
			gateway_id = input.gateway_id
			AND
			device_id = beeeon.to_device_id(input.device_id)
			AND
			module_id = input.module_id
		LIMIT 1)
	AND
	input.start_ts <= r.at
	AND
	r.at < input.end_ts
	AND
	r.value IS NOT NULL
GROUP BY 1
ORDER BY 1
