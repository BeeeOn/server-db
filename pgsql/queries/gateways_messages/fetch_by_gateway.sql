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
	gateway_id = $1::bigint
ORDER BY
	at, severity, key
