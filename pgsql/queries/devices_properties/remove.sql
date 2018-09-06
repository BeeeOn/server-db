DELETE
FROM
	beeeon.device_properties
WHERE
	device_id = beeeon.to_device_id($1)
	AND
	gateway_id = $2
	AND
	key = $3
