INSERT INTO beeeon.locations (
	id,
	name,
	gateway_id
)
VALUES (
	$1::uuid,
	$2::varchar,
	$3::bigint
)
