SELECT EXISTS (
	SELECT 1
	FROM
		beeeon.roles_in_gateway
	WHERE
		gateway_id = $1
)
