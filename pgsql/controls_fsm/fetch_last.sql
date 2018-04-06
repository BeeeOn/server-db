SELECT
	f.value as requested_value,
	(extract(epoch from f.requested_at) * 1000000)::bigint AS requested_at,
	(extract(epoch from f.accepted_at) * 1000000)::bigint AS accepted_at,
	(extract(epoch from f.finished_at) * 1000000)::bigint AS finished_at,
	f.failed AS failed,
	f.originator_user_id AS originator_user_id,
	(extract(epoch from r.at) * 1000000)::bigint AS recent_at,
	r.value AS recent_value
FROM
	beeeon.controls_fsm_last f
FULL OUTER JOIN
	beeeon.sensor_history_last r
ON
	f.gateway_id = r.gateway_id
	AND
	f.device_id = r.device_id
	AND
	f.module_id = r.module_id
WHERE
	f.gateway_id = $1::bigint
	AND
	f.device_id = beeeon.to_device_id($2)
	AND
	f.module_id = $3::smallint
