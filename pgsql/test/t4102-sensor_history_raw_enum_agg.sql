SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query_agg $$ `cat queries/sensors_history/huge_fetch_enum_agg.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION fetch_enum_agg(
		bigint, numeric(20, 0), smallint, bigint, bigint, bigint)
RETURNS TABLE (at bigint, value real, freq bigint) AS :query_agg LANGUAGE SQL;

SELECT plan(5);

SELECT is_empty(
	$$ SELECT * FROM fetch_enum_agg(
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
	timestamp '2017-7-20 12:55:12',
	timestamp '2017-7-20 12:55:12'
);

---
-- Insert testing time series:
--
--  time offset:   5   10   15   20   25   30
--  value:         0    1    1    2    2    3
---
INSERT INTO sensor_history (
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
	timestamp '2017-7-20 13:00:05',
	0
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 13:00:10',
	1
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 13:00:15',
	1
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 13:00:20',
	2
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 13:00:25',
	2
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 13:00:30',
	3
);

SELECT results_eq(
	$$ SELECT as_utc_timestamp(at), value, freq FROM fetch_enum_agg(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp '2017-7-20 13:00:31')::bigint,
		5
	) ORDER by at, value $$,
	$$ VALUES
		(timestamp '2017-7-20 13:00:05', 0::real, 1::bigint),
		(timestamp '2017-7-20 13:00:10', 1::real, 1::bigint),
		(timestamp '2017-7-20 13:00:15', 1::real, 1::bigint),
		(timestamp '2017-7-20 13:00:20', 2::real, 1::bigint),
		(timestamp '2017-7-20 13:00:25', 2::real, 1::bigint),
		(timestamp '2017-7-20 13:00:30', 3::real, 1::bigint)
	$$,
	'no real aggregation expected, just raw data (counts are 1)'
);

SELECT results_eq(
	$$ SELECT as_utc_timestamp(at) AS at, value, freq FROM fetch_enum_agg(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp '2017-7-20 13:00:31')::bigint,
		10
	) ORDER BY at, value $$,
	$$ VALUES
		-- the first is just alone
		(timestamp '2017-7-20 13:00:00', 0::real, 1::bigint),
		(timestamp '2017-7-20 13:00:10', 1::real, 2::bigint),
		(timestamp '2017-7-20 13:00:20', 2::real, 2::bigint),
		-- the last is just alone
		(timestamp '2017-7-20 13:00:30', 3::real, 1::bigint)
	$$,
	'expected enums aggregated by 10 seconds'
);

SELECT results_eq(
	$$ SELECT as_utc_timestamp(at) AS at, value, freq FROM fetch_enum_agg(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp '2017-7-20 13:00:31')::bigint,
		15
	) ORDER BY at, value $$,
	$$ VALUES
		(timestamp '2017-7-20 13:00:00', 0::real, 1::bigint),
		(timestamp '2017-7-20 13:00:00', 1::real, 1::bigint),
		(timestamp '2017-7-20 13:00:15', 1::real, 1::bigint),
		(timestamp '2017-7-20 13:00:15', 2::real, 2::bigint),
		-- the last is not aggregated with anything
		(timestamp '2017-7-20 13:00:30', 3::real, 1::bigint)
	$$,
	'expected enums aggregated by 15 seconds'
);

SELECT results_eq(
	$$ SELECT as_utc_timestamp(at) AS at, value, freq FROM fetch_enum_agg(
		1240795450208837::bigint,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		extract(epoch FROM timestamp '2017-7-20 13:00:00')::bigint,
		extract(epoch FROM timestamp '2017-7-20 13:00:31')::bigint,
		30
	) ORDER BY at, value $$,
	$$ VALUES
		(timestamp '2017-7-20 13:00:00', 0::real, 1::bigint),
		(timestamp '2017-7-20 13:00:00', 1::real, 2::bigint),
		(timestamp '2017-7-20 13:00:00', 2::real, 2::bigint),
		(timestamp '2017-7-20 13:00:30', 3::real, 1::bigint)
	$$,
	'expected enums aggregated by 30 seconds'
);

SELECT finish();
ROLLBACK;
