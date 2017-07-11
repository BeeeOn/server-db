SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('verified_identities_by_email_and_provider');

SELECT is_empty(
	$$ SELECT * FROM verified_identities_by_email_and_provider('example@example.org', 'testing') $$,
	'there are no verified identities yet'
);

SELECT finish();
ROLLBACK;
