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
			v.identity_id = input.identity_id
	) AS self
),
user_can AS (
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
		WHERE
			r.identity_id = input.identity_id
			AND
			u.user_id = input.user_id
	) AS see
)
SELECT
	user_is.self
	OR
	user_can.see
FROM
	user_is,
	user_can
