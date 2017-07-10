-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_accessible(
	_user_id uuid
)
RETURNS SETOF beeeon.gateway_with_status AS
$$
BEGIN
	RETURN QUERY
	SELECT
		DISTINCT g.id,
		g.name,
		g.altitude,
		g.latitude,
		g.longitude,
		extract(epoch from s.at)::bigint,
		s.version,
		host(s.ip)::varchar(45)
	FROM beeeon.gateways AS g
	JOIN beeeon.roles_in_gateway AS r
		ON g.id = r.gateway_id
	JOIN beeeon.verified_identities AS v
		ON v.identity_id = r.identity_id
	LEFT JOIN beeeon.gateways_status AS s
		ON s.gateway_id = g.id
	WHERE
		v.user_id = _user_id
		AND (
			s.at IS NULL
			OR
			s.at = beeeon.gateways_status_most_recent(g.id)
		);
END;
$$ LANGUAGE plpgsql;

COMMIT;
