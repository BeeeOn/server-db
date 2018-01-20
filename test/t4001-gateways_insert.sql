SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/gateways.create.sql`

BEGIN;

PREPARE gateways_insert(
	bigint, varchar, integer, double precision, double precision, varchar)
AS :query;

SELECT plan(3);

SELECT lives_ok(
	$$ EXECUTE gateways_insert(1240795450208837, 'first gateway', 3, 2.0, 1.0, 'Europe/Brussels') $$,
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
		AND
		timezone = 'Europe/Brussels'
	),
	'gateway of ID 1240795450208837 should have been inserted'
);

SELECT throws_ok(
	$$ EXECUTE gateways_insert(1240795450208837, 'first gateway', 0, 0.0, 0.0, 'Europe/London') $$,
	23505,
	NULL,
	'primary key violation when creating the same gateway twice'
);

SELECT finish();
ROLLBACK;
