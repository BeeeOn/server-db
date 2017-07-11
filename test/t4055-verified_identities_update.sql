SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('verified_identities_update');

SELECT ok(
	NOT verified_identities_update('3d865c6e-0408-463e-9ae1-c90a93689a08', 'url-to-picture', 'a-token'),
	'nothing to update, expect false'
);

SELECT finish();
ROLLBACK;
