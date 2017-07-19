SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(9);

SELECT has_function('sensor_history_recent_aggregate');

SELECT is_empty(
	$$ SELECT * FROM sensor_history_recent_aggregate(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		0::bigint,
		1500000000::bigint,
		30::bigint
	) $$,
	'there is no sensor history yet'
);

---
-- Tests on few data to see the exact results easily.
---

INSERT INTO gateways (id, name)
VALUES (1240795450208837, 'Testing GW 1');

INSERT INTO devices (gateway_id, id, name, type, first_seen, last_seen)
VALUES (
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	'Testing Device 1',
	0,
	timestamp with time zone '2017-7-20 12:55:12',
	timestamp with time zone '2017-7-20 12:55:12'
);

---
-- Insert testing time series:
--
--  time offset:   5   10   15   20   25   30
--  value:        20   21   22   23   24   25
--
-- Expected aggregations:
--
--  min: 10
--  max: 25
--  avg: 22.5
---
INSERT INTO sensor_history_recent (
	gateway_id,
	device_id,
	module_id,
	at,
	value
)
VALUES (
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:05',
	20
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:10',
	21
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:15',
	22
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:20',
	23
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:25',
	24
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:30',
	25
);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:31')::bigint,
		5
	) $$,
	$$ VALUES
		(timestamp with time zone '2017-7-20 13:00:05', 20::real, 20::real, 20::real),
		(timestamp with time zone '2017-7-20 13:00:10', 21::real, 21::real, 21::real),
		(timestamp with time zone '2017-7-20 13:00:15', 22::real, 22::real, 22::real),
		(timestamp with time zone '2017-7-20 13:00:20', 23::real, 23::real, 23::real),
		(timestamp with time zone '2017-7-20 13:00:25', 24::real, 24::real, 24::real),
		(timestamp with time zone '2017-7-20 13:00:30', 25::real, 25::real, 25::real)
	$$,
	'no real aggregation expected, just raw data'
);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:31')::bigint,
		10
	) $$,
	$$ VALUES
		-- the first is not aggregated with anything
		(timestamp with time zone '2017-7-20 13:00:00', 20::real, 20::real, 20::real),
		(timestamp with time zone '2017-7-20 13:00:10', (21 + 22)::real / 2::real, 21::real, 22::real),
		(timestamp with time zone '2017-7-20 13:00:20', (23 + 24)::real / 2::real, 23::real, 24::real),
		-- the last is not aggregated with anything
		(timestamp with time zone '2017-7-20 13:00:30', 25::real, 25::real, 25::real)
	$$,
	'expected data aggregated by 10 seconds'
);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:31')::bigint,
		15
	) $$,
	$$ VALUES
		(timestamp with time zone '2017-7-20 13:00:00', (20 + 21)::real / 2::real, 20::real, 21::real),
		(timestamp with time zone '2017-7-20 13:00:15', (22 + 23 + 24)::real / 3::real, 22::real, 24::real),
		-- the last is not aggregated with anything
		(timestamp with time zone '2017-7-20 13:00:30', 25::real, 25::real, 25::real)
	$$,
	'expected data aggregated by 15 seconds'
);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:31')::bigint,
		30
	) $$,
	$$ VALUES
		(timestamp with time zone '2017-7-20 13:00:00', (20 + 21 + 22 + 23 + 24)::real / 5::real, 20::real, 24::real),
		(timestamp with time zone '2017-7-20 13:00:30', 25::real, 25::real, 25::real)
	$$,
	'expected data aggregated by 30 seconds'
);

---
-- Tests on a huge data set.
---

INSERT INTO gateways (id, name)
VALUES (1416756209079877, 'Testing GW 2');

INSERT INTO devices (gateway_id, id, name, type, first_seen, last_seen)
VALUES (
	1416756209079877,
	to_device_id(11678152912333531137::numeric(20, 0)),
	'Testing Device 2',
	0,
	timestamp with time zone '2017-7-20 12:50:00',
	timestamp with time zone '2017-7-20 12:50:00'
);

-- Set seed to be deterministic.
SELECT setseed(0);

-- Insert deterministic random testing data with time-step of 5 seconds.
INSERT INTO sensor_history_recent (
	gateway_id,
	device_id,
	module_id,
	at,
	value
)
SELECT
	1416756209079877,
	to_device_id(11678152912333531137::numeric(20, 0)),
	0,
	timestamp with time zone '2017-7-20 13:00:00' + ((i - 1) * interval '5 seconds'),
	random()::real
FROM generate_series(1, 1000) AS i;

SELECT is(COUNT(*), 1000::bigint) FROM sensor_history_recent
WHERE
	gateway_id = 1416756209079877
	AND
	device_id = to_device_id(11678152912333531137::numeric(20, 0));


-- Check that the raw data are returned as expected.
SELECT setseed(0);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1416756209079877::bigint,
		11678152912333531137::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 14:24:00')::bigint,
		5
	) $$,
	$$
	-- generate the same random sequence
	WITH r AS (
		SELECT
			i,
			random()::real AS value
		FROM generate_series(1, 1000) AS i
	)
	SELECT
		timestamp with time zone '2017-7-20 13:00:00' + ((r.i - 1) * interval '5 seconds'),
		r.value,
		r.value,
		r.value
		FROM r;
	$$,
	'no real aggregation expected, just raw data'
);

-- Check that the aggregated data are returned as expected.
SELECT setseed(0);

SELECT results_eq(
	$$ SELECT to_timestamp(at), avg, min, max FROM sensor_history_recent_aggregate(
		1416756209079877::bigint,
		11678152912333531137::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp with time zone '2017-7-20 14:24:00')::bigint,
		10
	) $$,
	$$
	-- generate the same random sequence but as two values a row
	WITH r AS (
		SELECT
			i,
			random()::real AS first,
			random()::real AS second
		FROM generate_series(1, 500) AS i
	)
	SELECT
		timestamp with time zone '2017-7-20 13:00:00' + ((r.i - 1) * interval '10 seconds'),
		(r.first + r.second) / 2::real,
		LEAST(r.first, r.second),
		GREATEST(r.first, r.second)
		FROM r;
	$$,
	'expected data aggregated by 10 seconds'
);

SELECT finish();
ROLLBACK;
