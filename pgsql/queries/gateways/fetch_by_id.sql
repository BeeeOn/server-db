---
-- Fetch gateway with its most recent status by id.
---
SELECT
	g.id AS id,
	g.name AS name,
	g.altitude AS altitude,
	g.latitude AS latitude,
	g.longitude AS longitude,
	g.timezone AS timezone,
	extract(epoch from s.at)::bigint AS last_changed,
	s.version AS version,
	host(s.ip)::varchar(45) AS ip
FROM
	beeeon.gateways AS g
LEFT JOIN
	beeeon.gateways_status AS s
ON
	g.id = s.gateway_id
WHERE
	g.id = $1::bigint
	AND (
		s.at IS NULL
		OR
		s.at = beeeon.gateways_status_most_recent(g.id)
	)
LIMIT 1

