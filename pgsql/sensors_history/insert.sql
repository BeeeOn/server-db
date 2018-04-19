INSERT INTO beeeon.sensor_history_raw (
	gateway_id,
	device_id,
	module_id,
	at,
	value
)
	VALUES (
	$1::bigint,
	beeeon.to_device_id($2::numeric(20, 0)),
	$3::smallint,
	beeeon.as_utc_timestamp_us($4),
	$5::real
)
