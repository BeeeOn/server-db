SELECT
	r.id AS id,
	r.gateway_id AS gateway_id,
	r.identity_id AS identity_id,
	r.level AS level,
	extract(epoch FROM r.created)::bigint AS created,
	i.email AS identity_email,
	u.first_name AS first_name,
	u.last_name AS last_name,
	v.picture AS picture,
	g.owner_id = u.id AS is_owner
FROM
	beeeon.roles_in_gateway AS r
JOIN
	beeeon.identities AS i
ON
	r.identity_id = i.id
JOIN
	beeeon.legacy_gateways AS g
ON
	g.id = r.gateway_id
JOIN
	beeeon.verified_identities AS v
ON
	r.identity_id = v.identity_id
	JOIN
	beeeon.users AS u
ON
	u.id = v.user_id
WHERE
	r.gateway_id = $1
ORDER BY
	r.level,
	i.email
