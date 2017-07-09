-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.gateways_by_id (
	_id bigint
)
RETURNS SETOF beeeon.gateway_with_status AS
$$
BEGIN
	RETURN QUERY
		SELECT
			g.id,
			g.name,
			g.altitude,
			g.latitude,
			g.longitude,
			extract(epoch from s.at)::bigint,
			s.version,
			host(s.ip)::varchar(45)
		FROM beeeon.gateways AS g
		LEFT JOIN beeeon.gateways_status AS s
			ON g.id = s.gateway_id
		WHERE
			g.id = _id
			AND (
				s.at IS NULL
				OR
				s.at = beeeon.gateways_status_most_recent(_id)
			)
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
