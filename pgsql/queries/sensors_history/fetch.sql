SELECT
	extract(epoch FROM at)::bigint,
	value
FROM
	beeeon.sensor_history_last
WHERE
	gateway_id = $1
	AND
	device_id = beeeon.to_device_id($2)
	AND
	module_id = $3
