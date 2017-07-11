-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_by_gateway(
	_gateway_id bigint
)
RETURNS SETOF beeeon.role_in_gateway AS
$$
BEGIN
	RETURN QUERY
		SELECT
			r.id,
			r.gateway_id,
			r.identity_id,
			r.level,
			extract(epoch FROM r.created)::bigint,
			i.email
		FROM beeeon.roles_in_gateway AS r
		JOIN beeeon.identities AS i
			ON r.identity_id = i.id
		WHERE
			r.gateway_id = _gateway_id;
END;
$$ LANGUAGE plpgsql;

COMMIT;
