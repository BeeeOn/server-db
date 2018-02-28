SELECT
	DISTINCT g.id AS id,
	g.name AS name,
	g.altitude AS altitude,
	g.latitude AS latitude,
	g.longitude AS longitude,
	g.timezone AS timezone,
	extract(epoch FROM s.at)::bigint AS last_changed,
	s.version AS version,
	host(s.ip)::varchar(45) AS ip
FROM
	beeeon.gateways AS g
JOIN
	beeeon.gateways_status AS s
ON
	s.gateway_id = g.id
JOIN
	beeeon.roles_in_gateway AS r
ON
	r.gateway_id = g.id
JOIN
	beeeon.verified_identities AS v
ON
	v.identity_id = r.identity_id
WHERE
	r.level >= $1
	AND
	v.user_id = $2
	AND (
		s.at IS NULL
		OR
		s.at = beeeon.gateways_status_most_recent(g.id)
	)
