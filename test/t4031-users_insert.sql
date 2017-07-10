SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('users_insert');

SELECT lives_ok(
	$$ SELECT users_insert('8c3e5613-7692-4915-951d-68362505e4ce', 'Franta', 'Bubak', 'cs_CZ') $$,
	'no reason to fail on constraints'
);

SELECT finish();
ROLLBACK;
