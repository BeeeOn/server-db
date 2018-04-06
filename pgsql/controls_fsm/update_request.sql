UPDATE
	beeeon.controls_fsm
SET
	accepted_at = beeeon.as_utc_timestamp_us($1),
	finished_at = beeeon.as_utc_timestamp_us($2),
	failed = $3::boolean
WHERE
	gateway_id = $4::bigint
	AND
	device_id = beeeon.to_device_id($5::numeric(20, 0))
	AND
	module_id = $6
	AND
	requested_at = beeeon.as_utc_timestamp_us($7)
