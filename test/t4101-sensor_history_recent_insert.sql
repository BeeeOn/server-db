SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/sensors_history.insert.sql`

BEGIN;

PREPARE sensor_history_recent_insert
AS :query;

SELECT plan(1);

SELECT throws_ok(
	$$ EXECUTE sensor_history_recent_insert(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint,
		1500471778,
		0
	) $$,
	23503,
	NULL,
	'it must fail because of missing gateway and device'
);

SELECT finish();
ROLLBACK;
