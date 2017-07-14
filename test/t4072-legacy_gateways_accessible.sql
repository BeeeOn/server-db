SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('legacy_gateways_accessible');

SELECT is_empty(
	$$ SELECT * FROM legacy_gateways_accessible('56ffcd4a-49f3-406f-a452-e0c734f4ed8a') $$,
	'there is nothing yet in the gateways table'
);

SELECT finish();
ROLLBACK;
