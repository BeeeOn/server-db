SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(4);

SELECT has_function('gateways_insert');

SELECT lives_ok(
	$$ SELECT gateways_insert(1240795450208837, 'first gateway', 3, 2.0, 1.0) $$,
	'no reason to fail on constraints'
);

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.gateways
	WHERE
		id = 1240795450208837
		AND
		name = 'first gateway'
		AND
		altitude = 3
		AND
		latitude = 2
		AND
		longitude = 1
	),
	'gateway of ID 1240795450208837 should have been inserted'
);

SELECT throws_ok(
	$$ SELECT gateways_insert(1240795450208837, 'first gateway', 0, 0.0, 0.0) $$,
	23505,
	NULL,
	'primary key violation when creating the same gateway twice'
);

SELECT finish();
ROLLBACK;
