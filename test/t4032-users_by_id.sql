SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('users_by_id');

SELECT is_empty(
	$$ SELECT * FROM users_by_id('8c3e5613-7692-4915-951d-68362505e4ce') $$,
	'must be empty, there is no user yet'
);

SELECT finish();
ROLLBACK;
