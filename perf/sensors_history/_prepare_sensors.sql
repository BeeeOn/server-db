DO LANGUAGE plpgsql $$
BEGIN
	RAISE NOTICE 'scanning candidate sensors...';
END; $$;

---
-- Scan database for existing sensors with most data,
-- discover when they started and stopped to generate
-- and prepare records about them in to the table
-- candidate_sensors.
---
CREATE TEMPORARY TABLE candidate_sensors AS
WITH
sensors_stat AS (
	SELECT
		gateway_id,
		device_id,
		module_id,
		MIN(at) AS at_min,
		MAX(at) AS at_max,
		COUNT(*) AS count
	FROM
		beeeon.sensor_history_recent
	GROUP BY
		gateway_id, device_id, module_id
)
SELECT
	gateway_id,
	device_id,
	module_id,
	at_min,
	at_max,
	count
FROM
	sensors_stat
ORDER BY count DESC
LIMIT 2;

---
-- If no candidate sensors where found (empty database?), generate
-- some fake ones.
--
-- For fake data, we assume that gateway 1115569803521760 does not
-- exist.
---
DO LANGUAGE plpgsql $$
DECLARE
	_count bigint;
BEGIN
	SELECT COUNT(*) INTO _count FROM candidate_sensors;
	RAISE NOTICE 'found % candidate sensors', _count;

	IF _count <> 0 THEN
		RETURN;
	END IF;

	RAISE NOTICE 'generating fake candidate sensors';

	INSERT INTO beeeon.gateways VALUES
		(1115569803521760, 'testing gw',  1, 1.5, -1.5, 'Europe/Paris');

	INSERT INTO beeeon.devices (
		id,
		gateway_id,
		name,
		type,
		first_seen,
		last_seen
	)
	VALUES (
		beeeon.to_device_id(11678152912333531136::numeric(20, 0)),
		1115569803521760::bigint,
		'testing device',
		0,
		timestamp '2016-2-13 09:15:01',
		timestamp '2017-7-20 10:11:56'
	);

	RAISE NOTICE 'fake gateways and devices initialized';

	---
	-- 14 days of fake data 1 insert per 30 seconds.
	---
	INSERT INTO beeeon.sensor_history_recent
	SELECT
		1115569803521760,
		beeeon.to_device_id(11678152912333531136::numeric(20, 0)),
		0,
		at,
		0
	FROM generate_series(
		timestamp '2016-4-10 09:15:01',
		timestamp '2016-4-24 10:11:56',
		interval '30 seconds') AS at;

	RAISE NOTICE 'fake data for test sensor 0 inserted';

	---
	-- 31 days of fake data 1 insert per 5 minutes.
	---
	INSERT INTO beeeon.sensor_history_recent
	SELECT
		1115569803521760,
		beeeon.to_device_id(11678152912333531136::numeric(20, 0)),
		1,
		at,
		0
	FROM generate_series(
		timestamp '2016-3-20 09:15:01',
		timestamp '2016-4-20 10:11:56',
		interval '5 minutes') AS at;

	RAISE NOTICE 'fake data for test sensor 1 inserted';

	---
	-- Refil then candidate_sensors table by fake sensors.
	---
	INSERT INTO candidate_sensors
	WITH
	sensors_stat AS (
		SELECT
			gateway_id,
			device_id,
			module_id,
			MIN(at) AS at_min,
			MAX(at) AS at_max,
			COUNT(*) AS count
		FROM
			beeeon.sensor_history_recent
		GROUP BY
			gateway_id, device_id, module_id
	)
	SELECT
		gateway_id,
		device_id,
		module_id,
		at_min,
		at_max,
		count
	FROM
		sensors_stat
	WHERE
		gateway_id = 1115569803521760
	ORDER BY count DESC;

	RAISE NOTICE 'fake candidate sensors initialized';
END; $$;
