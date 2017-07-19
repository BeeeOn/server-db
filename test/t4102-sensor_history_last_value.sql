SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(3);

SELECT has_function('sensor_history_last_value');

SELECT is_empty(
	$$ SELECT * FROM sensor_history_last_value(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint
	) $$,
	'there is no sensor history yet'
);

SELECT is_empty(
	$$ SELECT * FROM sensor_history_last_value(
		1240795450208837,
		11678152912333531136::numeric(20, 0)
	) $$,
	'there is no sensor history yet'
);

SELECT finish();
ROLLBACK;
