SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('locations_update');

SELECT ok(
	NOT locations_update('fad5baf1-3bd8-4f7f-a06e-137ffb4ef924', 'Kitchen')
);

SELECT finish();
ROLLBACK;
