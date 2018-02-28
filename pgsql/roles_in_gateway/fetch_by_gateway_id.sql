SELECT
	r.id AS id,
	r.gateway_id AS gateway_id,
	r.identity_id AS identity_id,
	r.level AS level,
	extract(epoch FROM r.created)::bigint AS created,
	i.email AS identity_email
FROM
	beeeon.roles_in_gateway AS r
JOIN
	beeeon.identities AS i
ON
	r.identity_id = i.id
WHERE
	r.gateway_id = $1
