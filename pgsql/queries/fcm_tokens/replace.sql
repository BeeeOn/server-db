---
-- Replace token as specified by arguments.
---
WITH
-- Helper to name the input arguments.
input AS (
	SELECT
		$1 AS token_from,
		$2 AS token_to
),
-- Perform the actual insert of the new token.
do_insert AS (
	INSERT INTO beeeon.fcm_tokens
	SELECT
		input.token_to,
		user_id
	FROM
		beeeon.fcm_tokens,
		input
	WHERE
		token = input.token_from
)
-- Delete all occurences of the token to be replaced.
DELETE FROM beeeon.fcm_tokens
WHERE
	token IN (SELECT token_from FROM input)
