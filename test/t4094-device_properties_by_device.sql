SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('device_properties_by_device');

SELECT is_empty(
	$$ SELECT * FROM device_properties_by_device(11678152912333531136, 1240795450208837) $$,
	'there is nothing yet in the device_properties table'
);

SELECT finish();
ROLLBACK;
