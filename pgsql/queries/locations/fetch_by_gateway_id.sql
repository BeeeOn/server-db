SELECT
	id,
	name,
	gateway_id
FROM
	beeeon.locations
WHERE
	gateway_id = $1::bigint
