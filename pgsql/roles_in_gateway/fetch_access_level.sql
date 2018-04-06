SELECT
	MIN(r.level)
FROM
	beeeon.roles_in_gateway AS r
JOIN
	beeeon.verified_identities AS v
ON
	v.identity_id = r.identity_id
WHERE
	r.gateway_id = $1
	AND
	v.user_id = $2
