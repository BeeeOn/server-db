UPDATE
	beeeon.device_properties
SET
	value = $1,
	params = $2
WHERE
	device_id = beeeon.to_device_id($3)
	AND
	gateway_id = $4
	AND
	key = $5
