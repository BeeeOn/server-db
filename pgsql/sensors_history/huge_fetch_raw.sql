SELECT
	extract(epoch FROM r.at)::bigint,
	r.value
FROM
	beeeon.sensor_history_raw AS r
WHERE
	r.refid = (SELECT refid
		FROM beeeon.sensors
		WHERE
			gateway_id = $1::bigint
			AND
			device_id = beeeon.to_device_id($2::numeric(20, 0))
			AND
			module_id = $3::smallint
		LIMIT 1)
	AND
	beeeon.as_utc_timestamp($4::bigint) <= r.at
	AND
	r.at < beeeon.as_utc_timestamp($5::bigint)
ORDER BY
	r.at
