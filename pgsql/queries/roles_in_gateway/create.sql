INSERT INTO beeeon.roles_in_gateway (
	id,
	gateway_id,
	identity_id,
	level,
	created
)
VALUES (
	$1,
	$2,
	$3,
	$4,
	beeeon.as_utc_timestamp($5)
)

