-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_by_id(
	_id uuid
)
RETURNS SETOF beeeon.role_in_gateway AS
$$
BEGIN
	RETURN QUERY
		SELECT
			r.id,
			r.gateway_id,
			i.id,
			r.level,
			extract(epoch FROM r.created)::bigint,
			i.email
		FROM beeeon.roles_in_gateway AS r
		JOIN beeeon.identities AS i
			ON r.identity_id = i.id
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
