---
-- Insert status for the given gateway but only if the most
-- recent status already record is _different_ from the status
-- being inserted.
---
WITH
-- Helper to just name the input arguments.
input AS (
	SELECT
		$1::bigint AS gateway_id,
		beeeon.as_utc_timestamp($2) AS at,
		$3::varchar(40) AS version,
		$4::inet AS ip
),
-- Detect the most recent status _matching_ the status being inserted.
-- If there is *some*, we will not insert anything.
status AS (
	SELECT
		count(*) > 0 AS same
	FROM
		beeeon.gateways_status AS s,
		input
	WHERE
		s.gateway_id = input.gateway_id
		AND
		s.version = input.version
		AND
		s.ip = input.ip
		AND
		s.at = beeeon.gateways_status_most_recent(input.gateway_id)
)
-- Insert the given input status only if the most recent status is not the same.
INSERT INTO beeeon.gateways_status (
	gateway_id,
	at,
	version,
	ip
)
SELECT
	input.gateway_id,
	input.at,
	input.version, 
	input.ip
FROM
	input,
	status
WHERE
	NOT status.same
