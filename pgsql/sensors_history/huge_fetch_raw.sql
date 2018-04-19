SELECT
	extract(epoch FROM s.at)::bigint,
	s.value
FROM
	beeeon.sensor_history AS s
WHERE
	s.gateway_id = $1::bigint
	AND
	s.device_id = beeeon.to_device_id($2::numeric(20, 0))
	AND
	s.module_id = $3::smallint
	AND
	beeeon.as_utc_timestamp($4::bigint) <= s.at
	AND
	s.at < beeeon.as_utc_timestamp($5::bigint)
ORDER BY
	s.at
