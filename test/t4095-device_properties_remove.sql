SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('device_properties_remove');

SELECT lives_ok(
	$$ SELECT device_properties_remove(11678152912333531136, 1240795450208837, 0::smallint) $$,
	'removing of non-existing device property should not fail'
);

SELECT finish();
ROLLBACK;
