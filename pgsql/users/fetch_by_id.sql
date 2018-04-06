SELECT
	id,
	first_name,
	last_name,
	locale
FROM
	beeeon.users
WHERE
	id = $1
LIMIT 1
