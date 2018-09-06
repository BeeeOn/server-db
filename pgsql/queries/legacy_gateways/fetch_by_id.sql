SELECT
	g.id AS id,
	g.name AS name,
	g.altitude AS altitude,
	g.latitude AS latitude,
	g.longitude AS longitude,
	g.timezone AS timezone,
	extract(epoch from s.at)::bigint AS last_changed,
	s.version AS version,
	host(s.ip)::varchar(45) AS ip,
	g.roles_count AS roles_count,
	g.devices_count AS devices_count,
	g.owner_id AS owner_id,
	o.first_name AS owner_first_name,
	o.last_name AS owner_last_name,
	(
		SELECT
			level
		FROM
			beeeon.users_of_gateway
		WHERE
			gateway_id = g.id
			AND user_id = $1
	) AS access_level
FROM
	beeeon.legacy_gateways AS g
LEFT JOIN
	beeeon.gateways_status AS s
ON
	s.gateway_id = g.id
LEFT JOIN
	beeeon.users AS o
ON
	o.id = g.owner_id
WHERE
	g.id = $2
	AND (
		s.at IS NULL
		OR
		s.at = beeeon.gateways_status_most_recent(g.id))
LIMIT 1
