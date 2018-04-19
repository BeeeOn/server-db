SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(25);

SELECT has_table('sensor_history_last');
SELECT has_pk('sensor_history_last');
SELECT has_fk('sensor_history_last');

SELECT has_column('sensor_history_last', 'gateway_id');
SELECT col_type_is('sensor_history_last', 'gateway_id', 'bigint');
SELECT col_not_null('sensor_history_last', 'gateway_id');
SELECT col_is_fk('sensor_history_last', 'gateway_id');

SELECT has_column('sensor_history_last', 'device_id');
SELECT col_type_is('sensor_history_last', 'device_id', 'bigint');
SELECT col_not_null('sensor_history_last', 'device_id');

SELECT col_is_fk('sensor_history_last', ARRAY['gateway_id', 'device_id']);

SELECT has_column('sensor_history_last', 'module_id');
SELECT col_type_is('sensor_history_last', 'module_id', 'smallint');
SELECT col_not_null('sensor_history_last', 'module_id');

SELECT col_is_pk('sensor_history_last', ARRAY['gateway_id', 'device_id', 'module_id']);

SELECT has_column('sensor_history_last', 'at');
SELECT col_type_is('sensor_history_last', 'at', 'timestamp without time zone');
SELECT col_not_null('sensor_history_last', 'at');

SELECT has_column('sensor_history_last', 'value');
SELECT col_type_is('sensor_history_last', 'value', 'real');
SELECT col_is_null('sensor_history_last', 'value');

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (
	1240795450208837,
	'testing gateway',
	0,
	0.0,
	0.0
);

INSERT INTO devices
	(id, gateway_id, name, type, first_seen, last_seen)
VALUES (
	to_device_id(11678152912333531136::numeric(20, 0)),
	1240795450208837,
	'testing device',
	1,
	timestamp '2017-12-20 12:50',
	timestamp '2017-12-20 12:50'
);

SELECT is_empty(
	$$ SELECT * FROM sensor_history_last $$,
	'there are no sensor data yet'
);

---
-- Insert into the sensor_history and expect that
-- the materialized view sensor_history_last is updated.
---
INSERT INTO beeeon.sensor_history
	(gateway_id, device_id, module_id, at, value)
VALUES (
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-12-20 13:00',
	5.0
);

SELECT results_eq(
	$$ SELECT * FROM sensor_history_last $$,
	$$ VALUES (
		1240795450208837::bigint,
		to_device_id(11678152912333531136::numeric(20, 0)),
		0::smallint,
		timestamp '2017-12-20 13:00',
		5.0::real
	) $$,
	'expected 1 last value'
);

---
-- Insert into the sensor_history and expect that
-- the materialized view sensor_history_last contains only
-- the newer value.
---
INSERT INTO beeeon.sensor_history
	(gateway_id, device_id, module_id, at, value)
VALUES (
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-12-20 13:01',
	6.0
);

SELECT results_eq(
	$$ SELECT * FROM sensor_history_last $$,
	$$ VALUES (
		1240795450208837::bigint,
		to_device_id(11678152912333531136::numeric(20, 0)),
		0::smallint,
		timestamp '2017-12-20 13:01',
		6.0::real
	) $$,
	'expected the newer value'
);

---
-- Insert old data into the sensor_history and expect
-- that the materialized view sensor_history_last contains the
-- same value - no update have been performed.
---
INSERT INTO beeeon.sensor_history
	(gateway_id, device_id, module_id, at, value)
VALUES (
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-12-20 12:59',
	7.0
);

SELECT results_eq(
	$$ SELECT * FROM sensor_history_last $$,
	$$ VALUES (
		1240795450208837::bigint,
		to_device_id(11678152912333531136::numeric(20, 0)),
		0::smallint,
		timestamp '2017-12-20 13:01',
		6.0::real
	) $$,
	'expected the newer value'
);

SELECT finish();
ROLLBACK;
