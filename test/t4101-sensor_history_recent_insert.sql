SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/sensors_history/insert.sql`

BEGIN;

PREPARE sensor_history_recent_insert
AS :query;

SELECT plan(11);

SELECT throws_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		1500471778000000,
		0
	) $$,
	23503,
	NULL,
	'it must fail because of missing gateway and device'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (1240795450208837, 'testing gateway', 0, 0.0, 0.0);

INSERT INTO devices (
	id,
	gateway_id,
	name,
	type,
	first_seen,
	last_seen
)
VALUES (
	to_device_id(11678152912333531136::numeric(20, 0)),
	1240795450208837::bigint,
	'testing device',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22'
);

SELECT lives_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		1500471778000000,
		26
	) $$,
	'there is no reason to fail while inserting data'
);

SELECT lives_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		1500471778000001,
		15
	) $$,
	'there is no reason to fail while inserting data shortly after each other'
);

SELECT lives_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		1::smallint,
		1500471778000000,
		17
	) $$,
	'there is no reason to fail while inserting data for 2 modules with same timestamp'
);

SELECT results_eq(
	$$ SELECT value, at FROM beeeon.sensor_history_recent ORDER BY module_id, at $$,
	$$ VALUES (
		26::real,
		timestamp '2017-07-19 13:42:58.000000'
	),
	(
		15::real,
		timestamp '2017-07-19 13:42:58.000001'
	),
	(
		17::real,
		timestamp '2017-07-19 13:42:58.000000'
	) $$,
	'2 values should have been inserted'
);

SELECT throws_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		1::smallint,
		1500471778000000,
		16
	) $$,
	23505,
	NULL,
	'constraint violation for duplicate timestamp should be raised'
);

SELECT results_eq(
	$$ SELECT value, at FROM beeeon.sensor_history_last ORDER BY module_id, at $$,
	$$ VALUES (
		15::real,
		timestamp '2017-07-19 13:42:58.000001'
	),
	(
		17::real,
		timestamp '2017-07-19 13:42:58.000000'
	) $$,
	'2 modules with the most recent values should be in materialized view only'
);

SELECT lives_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		1::smallint,
		1500471777999999,
		11
	) $$,
	'inserting older (out-of-order) data should work'
);

SELECT results_eq(
	$$ SELECT value, at FROM beeeon.sensor_history_recent ORDER BY module_id, at $$,
	$$ VALUES (
		26::real,
		timestamp '2017-07-19 13:42:58.000000'
	),
	(
		15::real,
		timestamp '2017-07-19 13:42:58.000001'
	),
	(
		11::real,
		timestamp '2017-07-19 13:42:57.999999'
	),
	(
		17::real,
		timestamp '2017-07-19 13:42:58.000000'
	) $$,
	'out-of-order data should be inserted successfully'
);

SELECT results_eq(
	$$ SELECT value, at FROM beeeon.sensor_history_last ORDER BY module_id, at $$,
	$$ VALUES (
		15::real,
		timestamp '2017-07-19 13:42:58.000001'
	),
	(
		17::real,
		timestamp '2017-07-19 13:42:58.000000'
	) $$,
	'out-of-order data should not modify materialized view'
);

SELECT throws_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		1::smallint,
		1500471779124324,
		'NaN'::real
	) $$,
	23514,
	NULL,
	'constraint violation for NaN value'
);

SELECT finish();
ROLLBACK;
