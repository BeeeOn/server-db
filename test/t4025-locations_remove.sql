SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('locations_remove');

SELECT lives_ok(
	$$ SELECT locations_remove('53e14bba-31d2-4819-8cfb-591caaf89d06') $$,
	'removing of non-existing location should not fail'
);

SELECT finish();
ROLLBACK;
