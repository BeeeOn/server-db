INSERT INTO beeeon.device_properties (
	device_id,
	gateway_id,
	key,
	value,
	params
)
VALUES (
	beeeon.to_device_id($1),
	$2,
	$3,
	$4,
	$5
)
