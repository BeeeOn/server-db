UPDATE
	beeeon.controls_fsm
SET
	accepted_at = beeeon.as_utc_timestamp_us($1)
WHERE
	gateway_id = $2::bigint
	AND
	device_id = beeeon.to_device_id($3::numeric(20, 0))
	AND
	module_id = $4
	AND
	requested_at = beeeon.as_utc_timestamp_us($5)
	AND
	accepted_at IS NULL
	AND
	finished_at IS NULL
