SELECT
	beeeon.from_device_id(id) AS id,
	gateway_id AS gateway_id,
	location_id AS location_id,
	name AS name,
	type AS type,
	refresh AS refresh,
	battery AS battery,
	signal AS signal,
	extract(epoch FROM first_seen)::bigint AS first_seen,
	extract(epoch FROM last_seen)::bigint AS last_seen,
	NULL::bigint AS active_since
FROM
	beeeon.devices
WHERE
	active_since IS NULL
	AND
	gateway_id = $1
