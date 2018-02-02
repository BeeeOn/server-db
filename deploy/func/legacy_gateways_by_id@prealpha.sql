-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.legacy_gateways_by_id(
	_user_id uuid,
	_id bigint
)
RETURNS SETOF beeeon.legacy_gateway AS
$$
BEGIN
	RETURN QUERY
		SELECT
			g.id,
			g.name,
			g.altitude,
			g.latitude,
			g.longitude,
			g.timezone,
			extract(epoch from s.at)::bigint,
			s.version,
			host(s.ip)::varchar(45),
			g.roles_count,
			g.devices_count,
			g.owner_id,
			o.first_name,
			o.last_name,
			(SELECT level FROM beeeon.users_of_gateway
				WHERE
					gateway_id = g.id
					AND
					user_id = _user_id) AS access_level
		FROM beeeon.legacy_gateways AS g
		LEFT JOIN beeeon.gateways_status AS s
			ON s.gateway_id = g.id
		LEFT JOIN beeeon.users AS o ON o.id = g.owner_id
		WHERE
			g.id = _id
			AND (
				s.at IS NULL
				OR
				s.at = beeeon.gateways_status_most_recent(g.id)
			)
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
