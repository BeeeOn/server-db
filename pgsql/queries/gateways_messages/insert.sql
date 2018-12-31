---
-- Rotate the queue of the target gateway that is to be
-- inserted. The maximal count of messages per gateway
-- is given as parameter $7. Thus, delete oldest messages
-- in the way where N - 1 messages is preserved (the rest
-- is deleted) and one new message is added by the insert,
-- for N = $7.
--
-- Due to ODBC stupidity, we have to first create the CTE
-- input with all arguments. ODBC fails on binding a single
-- argument twice (probably because it does not support
-- reordering of arguments in prepared statements).
---
WITH
input AS (
	SELECT
		$1::uuid AS id,
		$2::bigint AS gateway_id,
		$3::bigint AS at,
		$4::smallint AS severity,
		$5::varchar(64) AS key,
		$6 AS context
),
rotate_queue AS (
	DELETE FROM beeeon.gateways_messages AS m
	USING input
	WHERE
		m.gateway_id = input.gateway_id
		AND
		m.id NOT IN (
			SELECT p.id
			FROM beeeon.gateways_messages AS p, input
			WHERE
				p.gateway_id = input.gateway_id
			ORDER BY p.at DESC
			LIMIT ($7::bigint - 1)
		)
)
INSERT INTO beeeon.gateways_messages (
	id,
	gateway_id,
	at,
	severity,
	key,
	context
)
SELECT
	id,
	gateway_id,
	beeeon.as_utc_timestamp_us(at),
	severity,
	key,
	context::jsonb
FROM input
LIMIT 1
