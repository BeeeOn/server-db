SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('sensor_history_recent_insert');

SELECT throws_ok(
	$$ SELECT sensor_history_recent_insert(
		1240795450208837,
		beeeon.to_device_id(11678152912333531136),
		0::smallint,
		to_timestamp(1500471778) at time zone 'UTC',
		0
	) $$,
	23503,
	NULL,
	'it must fail because of missing gateway and device'
);

SELECT finish();
ROLLBACK;
