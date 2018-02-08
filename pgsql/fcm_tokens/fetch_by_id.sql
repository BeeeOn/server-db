---
-- Fetch user who has registered the given token.
---
SELECT
	t.token AS token,
	u.id AS user_id,
	u.first_name AS user_first_name,
	u.last_name AS user_last_name,
	u.locale AS user_locale
FROM
	beeeon.fcm_tokens AS t
JOIN
	beeeon.users AS u
ON
	t.user_id = u.id
WHERE
	t.token = $1
LIMIT 1
