SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat queries/roles_in_gateway/remove_all.sql`

BEGIN;

PREPARE roles_in_gateway_remove_gateway_all(bigint)
AS :query;

SELECT plan(1);

SELECT lives_ok(
	$$ EXECUTE roles_in_gateway_remove_gateway_all(1240795450208837) $$,
	'removing of non-existing role via a non-existing gateway should not fail'
);

SELECT finish();
ROLLBACK;
