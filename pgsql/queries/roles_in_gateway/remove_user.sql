DELETE
FROM
	beeeon.roles_in_gateway
WHERE
	identity_id IN (
		SELECT
			identity_id
		FROM
			beeeon.verified_identities
		WHERE
			user_id = $1
	)
	AND
	gateway_id = $2
