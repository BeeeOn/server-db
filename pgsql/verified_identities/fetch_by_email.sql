SELECT
	v.id AS id,
	v.identity_id AS identity_id,
	v.user_id AS user_id,
	v.provider AS provider,
	v.picture AS picture,
	v.access_token AS access_token,
	i.email AS identity_email,
	u.first_name AS user_first_name,
	u.last_name AS user_last_name,
	u.locale AS user_locale
FROM
	beeeon.verified_identities AS v
JOIN
	beeeon.identities AS i
ON
	v.identity_id = i.id
JOIN
	beeeon.users AS u
ON
	v.user_id = u.id
WHERE
	i.email = $1
ORDER BY
	provider
