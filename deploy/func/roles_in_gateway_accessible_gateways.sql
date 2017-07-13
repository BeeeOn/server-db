-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_accessible_gateways(
	_at_least integer,
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
			extract(epoch FROM s.at)::bigint,
			s.version,
			host(s.ip)::varchar(45)
		FROM beeeon.gateways AS g
		JOIN beeeon.gateways_status AS s
			ON s.gateway_id = g.id
		JOIN beeeon.roles_in_gateway AS r
			ON r.gateway_id = g.id
		JOIN beeeon.verified_identities AS v
			ON v.identity_id = r.identity_id
		WHERE
			r.level >= _at_least
			AND
			v.user_id = _user_id
			AND (
				s.at IS NULL
				OR
				s.at = beeeon.gateways_status_most_recent(g.id)
			);
END;
$$ LANGUAGE plpgsql;

COMMIT;
