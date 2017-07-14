SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('device_properties_update');

SELECT ok(
	NOT device_properties_update(
		11678152912333531136,
		1240795450208837::bigint,
		0::smallint,
		'anything'::text,
		NULL::text
	),
	'there is nothing to update'
);

SELECT finish();
ROLLBACK;
