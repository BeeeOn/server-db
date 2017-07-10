SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('locations_by_id');

SELECT is_empty(
	$$ SELECT * FROM locations_by_id('cc72f7ea-e8be-4379-8bf5-4cf26749b049') $$,
	'there is nothing yet in the locations table'
);

SELECT finish();
ROLLBACK;
