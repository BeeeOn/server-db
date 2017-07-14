-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.roles_in_gateway_access_level(
	_gateway_id bigint,
	_user_id uuid
)
RETURNS smallint AS
$$
DECLARE
	result smallint;
BEGIN
	SELECT MIN(r.level)
	INTO result
	FROM beeeon.roles_in_gateway AS r
	JOIN beeeon.verified_identities AS v
		ON v.identity_id = r.identity_id
	WHERE
		r.gateway_id = _gateway_id
		AND
		v.user_id = _user_id;

	RETURN result;
END;
$$ LANGUAGE plpgsql;

COMMIT;
