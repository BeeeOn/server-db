UPDATE
	beeeon.devices
SET
	location_id = $1,
	name = $2,
	type = $3,
	refresh = $4,
	battery = $5,
	signal = $6,
	last_seen = beeeon.now_utc(),
	active_since = beeeon.as_utc_timestamp($7)
WHERE
	id = beeeon.to_device_id($8)
	AND
	gateway_id = $9
