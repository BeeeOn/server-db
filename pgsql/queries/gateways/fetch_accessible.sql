---
-- Fetch all gateways accessible for the given user (by its id).
-- This contains gateways where exists any role for that user.
-- It also fetches the most recent status of the gateways.
---
SELECT
	DISTINCT g.id AS id,
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
JOIN
	beeeon.roles_in_gateway AS r
ON
	g.id = r.gateway_id
JOIN
	beeeon.verified_identities AS v
ON
	v.identity_id = r.identity_id
LEFT JOIN
	beeeon.gateways_status AS s
ON
	s.gateway_id = g.id
WHERE
	v.user_id = $1::uuid
	AND (
		s.at IS NULL
		OR
		s.at = beeeon.gateways_status_most_recent(g.id)
	)

