SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('identities_by_email');

SELECT is_empty(
	$$ SELECT * FROM identities_by_email('example@example.org') $$,
	'there is nothing yet in the identities table'
);

SELECT finish();
ROLLBACK;
