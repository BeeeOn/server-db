SELECT
	id,
	gateway_id,
	(extract(epoch from at) * 1000000)::bigint AS at,
	severity,
	key,
	context::text
FROM
	beeeon.gateways_messages
WHERE
	id = $1::uuid
	AND
	gateway_id = $2::bigint
