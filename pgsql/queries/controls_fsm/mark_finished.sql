UPDATE
	beeeon.controls_fsm
SET
	finished_at = beeeon.as_utc_timestamp_us($1),
	failed = $2::boolean
WHERE
	gateway_id = $3::bigint
	AND
	device_id = beeeon.to_device_id($4::numeric(20, 0))
	AND
	module_id = $5
	AND
	requested_at = beeeon.as_utc_timestamp_us($6)
	AND
	finished_at is NULL
