SELECT EXISTS (
	SELECT 1
	FROM
		beeeon.roles_in_gateway
	WHERE
		level > $1
		AND
		gateway_id = $2
		AND
		identity_id NOT IN (
			SELECT
				identity_id
			FROM
				beeeon.verified_identities
			WHERE
				user_id = $3
		)
)
