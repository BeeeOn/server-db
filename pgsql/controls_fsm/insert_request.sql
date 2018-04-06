INSERT INTO beeeon.controls_fsm (
	gateway_id,
	device_id,
	module_id,
	value,
	requested_at,
	accepted_at,
	finished_at,
	failed,
	originator_user_id
)
	VALUES (
	$1::bigint,
	beeeon.to_device_id($2::numeric(20, 0)),
	$3::smallint,
	$4::real,
	beeeon.as_utc_timestamp_us($5),
	beeeon.as_utc_timestamp_us($6),
	beeeon.as_utc_timestamp_us($7),
	$8::boolean,
	$9::uuid
)
