SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(1);

SELECT throws_ok(
	$$ SELECT beeeon.always_fail('unknown reason') $$,
	'P0001',
	NULL,
	'calling always_fail must always fail :)'
);

SELECT finish();
ROLLBACK;
