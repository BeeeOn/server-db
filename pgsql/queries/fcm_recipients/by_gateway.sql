---
-- Obtain all tokens and their users that are related
-- to the given gateway. This consists of users with
-- a role in the gateway.
---
SELECT
	t.token AS token,
	t.user_id AS user_id,
	u.first_name AS user_first_name,
	u.last_name AS user_last_name,
	u.locale AS user_locale
FROM
	beeeon.fcm_tokens AS t
JOIN
	beeeon.verified_identities AS v
ON
	t.user_id = v.user_id
JOIN
	beeeon.roles_in_gateway AS r
ON
	r.identity_id = v.identity_id
JOIN
	beeeon.users AS u
ON
	u.id = t.user_id
WHERE
	r.gateway_id = $1
