INSERT INTO beeeon.verified_identities (
	id,
	identity_id,
	user_id,
	provider,
	picture,
	access_token
)
VALUES (
	$1,
	$2,
	$3,
	$4,
	$5,
	$6
)

