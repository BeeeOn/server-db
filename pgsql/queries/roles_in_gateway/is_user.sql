SELECT EXISTS(
	SELECT 1
	FROM
		beeeon.roles_in_gateway AS r
	JOIN
		beeeon.verified_identities AS v
	ON
		r.identity_id = v.identity_id
	JOIN
		beeeon.users AS u
	ON
		u.id = v.user_id
	WHERE
		r.id = $1
		AND
		u.id = $2
)
