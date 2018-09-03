SELECT
	id,
	name,
	gateway_id
FROM
	beeeon.locations
WHERE
	id = $1
LIMIT 1
