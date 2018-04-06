INSERT INTO beeeon.devices (
	id,
	gateway_id,
	location_id,
	name,
	type,
	refresh,
	battery,
	signal,
	first_seen,
	last_seen,
	active_since
)
VALUES (
	beeeon.to_device_id($1),
	$2,
	$3,
	$4,
	$5,
	$6,
	$7,
	$8,
	beeeon.as_utc_timestamp($9),
	beeeon.as_utc_timestamp($10),
	beeeon.as_utc_timestamp($11)
)
