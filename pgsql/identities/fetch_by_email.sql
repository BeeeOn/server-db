SELECT
	id,
	email
FROM
	beeeon.identities
WHERE
	email = $1
LIMIT 1

