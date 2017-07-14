-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.legacy_gateways_accessible(
	_user_id uuid
)
RETURNS SETOF beeeon.legacy_gateway AS
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
			host(s.ip)::varchar(45),
			g.roles_count,
			g.devices_count,
			g.owner_id,
			o.first_name,
			o.last_name,
			u.level
		FROM beeeon.legacy_gateways AS g
		JOIN beeeon.users_of_gateway AS u
			ON u.gateway_id = g.id
		LEFT JOIN beeeon.gateways_status AS s
			ON s.gateway_id = g.id
		LEFT JOIN beeeon.users AS o
			ON o.id = g.owner_id
		WHERE
			u.user_id = _user_id
			AND (
				s.at IS NULL
				OR
				s.at = beeeon.gateways_status_most_recent(g.id)
			);
END;
$$ LANGUAGE plpgsql;

COMMIT;
