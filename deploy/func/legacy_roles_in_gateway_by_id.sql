-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.legacy_roles_in_gateway_by_id(
	_id uuid
)
RETURNS TABLE (
	id uuid,
	gateway_id bigint,
	identity_id uuid,
	level smallint,
	created bigint,
	identity_email varchar(250),
	first_name varchar(250),
	last_name varchar(250),
	picture varchar(250),
	is_owner boolean
) AS
$$
BEGIN
	RETURN QUERY
                SELECT
			r.id,
			r.gateway_id,
			r.identity_id,
			r.level,
			extract(epoch FROM r.created)::bigint,
			i.email,
			u.first_name,
			u.last_name,
			v.picture,
			g.owner_id = u.id
		FROM beeeon.roles_in_gateway AS r
		JOIN beeeon.identities AS i
			ON r.identity_id = i.id 
		JOIN beeeon.legacy_gateways AS g
			ON g.id = r.gateway_id
		JOIN beeeon.verified_identities AS v
			on r.identity_id = v.identity_id
		JOIN beeeon.users AS u
			ON u.id = v.user_id
		WHERE
			r.id = _id
		LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMIT;
