-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.align_timestamp(
		ts timestamp,
		alignment integer)
RETURNS timestamp AS
$$
SELECT
--	to_timestamp(floor(extract(epoch FROM ts))::bigint - (
--		(24 * 60 * 60 * date_part('day', ts)::bigint)
--		+ (60 * 60 * date_part('hour', ts)::bigint)
--		+ (60 * date_part('minute', ts)::bigint)
--		+ floor(date_part('second', ts))::bigint
--	) % alignment) AT TIME ZONE 'UTC';
	(CASE
	WHEN alignment <= 1 THEN
		date_trunc('second', ts)
	WHEN alignment < 60 THEN
		date_trunc('second', ts) - (floor(date_part('second', ts))::integer % alignment) * interval '1 second'
	WHEN alignment = 60 THEN
		date_trunc('minute', ts)
	WHEN alignment < 3600 THEN
		date_trunc('second', ts) - (floor(date_part('minute', ts) * 60 + date_part('second', ts))::integer % alignment) * interval '1 second'
	WHEN alignment = 3600 THEN
		date_trunc('hour', ts)
	WHEN alignment < 86400 THEN
		date_trunc('second', ts) - (floor(date_part('hour', ts) * 3600 + date_part('minute', ts) * 60 + date_part('second', ts))::integer % alignment) * interval '1 second'
	WHEN alignment = 86400 THEN
		date_trunc('day', ts)
	ELSE
		NULL
	END)
$$ IMMUTABLE LANGUAGE SQL;

COMMIT;
