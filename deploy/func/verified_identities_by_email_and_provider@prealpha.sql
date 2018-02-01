-- beeeon-server pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.verified_identities_by_email_and_provider(
	_email varchar(250),
	_provider varchar(250)
)
RETURNS SETOF beeeon.verified_identity AS
$$
BEGIN
	RETURN QUERY
		SELECT
			v.id,
			v.identity_id,
			v.user_id,
			v.provider,
			v.picture,
			v.access_token,
			i.email,
			u.first_name,
			u.last_name
		FROM beeeon.verified_identities AS v
		JOIN beeeon.identities AS i
			ON v.identity_id = i.id
		JOIN beeeon.users AS u
			ON v.user_id = u.id
		WHERE
			i.email = _email
			AND
			v.provider = _provider
		LIMIT 1;

END;
$$ LANGUAGE plpgsql;

COMMIT;
