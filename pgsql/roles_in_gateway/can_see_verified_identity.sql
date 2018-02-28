WITH
input AS (
	SELECT
		$1::uuid AS identity_id,
		$2::uuid AS user_id
),
user_is AS (
	SELECT EXISTS (
		SELECT *
		FROM
			beeeon.verified_identities AS v,
			input
		WHERE
			v.user_id = input.user_id
			AND
			v.id = input.identity_id
	) AS self
),
can_see AS (
	SELECT EXISTS (
		SELECT *
		FROM
			beeeon.roles_in_gateway AS r
		CROSS JOIN
			input
		JOIN
			beeeon.users_of_gateway AS u
		ON
			u.gateway_id = r.gateway_id
		JOIN
			beeeon.verified_identities AS v
		ON
			v.identity_id = r.identity_id
		WHERE
			v.id = input.identity_id
			AND
			u.user_id = input.user_id) AS identity
)
SELECT
	user_is.self
	OR
	can_see.identity
FROM
	user_is, can_see
