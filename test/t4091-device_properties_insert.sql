SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('device_properties_insert');

SELECT throws_ok(
	$$ SELECT device_properties_insert(
		11678152912333531136,
		1240795450208837,
		0::smallint,
		'any arbitrary data'::text,
		NULL::text
	) $$,
	23503,
	NULL,
	'no such device and gateway exist'
);

SELECT finish();
ROLLBACK;
