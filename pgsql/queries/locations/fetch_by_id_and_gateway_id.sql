SELECT
	id,
	name,
	gateway_id
FROM
	beeeon.locations
WHERE
	id = $1::uuid
	AND
	gateway_id = $2::bigint
