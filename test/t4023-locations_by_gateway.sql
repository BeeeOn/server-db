SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('locations_by_gateway');

SELECT is_empty(
	$$ SELECT * FROM locations_by_gateway(1115569803521760) $$,
	'there is nothing yet in the locations table'
);

SELECT finish();
ROLLBACK;
