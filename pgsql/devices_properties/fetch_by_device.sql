SELECT
	beeeon.from_device_id(device_id),
	gateway_id,
	key,
	value,
	params
FROM
	beeeon.device_properties
WHERE
	device_id = beeeon.to_device_id($1)
	AND
	gateway_id = $2
