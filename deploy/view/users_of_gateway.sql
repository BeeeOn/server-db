-- beeeon-server, pg

BEGIN;

CREATE VIEW beeeon.users_of_gateway AS
	SELECT
		DISTINCT v.user_id AS user_id,
		g.id AS gateway_id,
		r.id AS role_id,
		r.identity_id AS identity_id,
		r.created AS created,
		r.level AS level
	FROM beeeon.gateways AS g
	JOIN beeeon.roles_in_gateway AS r
		ON g.id = r.gateway_id
	JOIN beeeon.verified_identities AS v
		ON r.identity_id = v.identity_id
	WHERE
		r.level = (
			SELECT MAX(level)
			FROM beeeon.roles_in_gateway AS subr
			JOIN beeeon.verified_identities AS subv
				ON subr.identity_id = subv.identity_id
			WHERE subv.user_id = v.user_id
		);

COMMIT;
