UPDATE
	beeeon.verified_identities
SET
	picture = $2,
	access_token = $3
WHERE
	id = $1
