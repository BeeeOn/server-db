SELECT
	token,
	user_id
FROM
	beeeon.fcm_tokens
WHERE
	user_id = $1
