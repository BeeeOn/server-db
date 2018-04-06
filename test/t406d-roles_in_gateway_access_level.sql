SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ '`cat pgsql/roles_in_gateway/fetch_access_level.sql`' $$'

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_access_level(bigint, uuid)
RETURNS smallint AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT lives_ok(
	$$ SELECT * FROM roles_in_gateway_access_level(1240795450208837, 'b6c168de-32c0-45a9-b23e-c936ac217ef1') $$,
	'it should not fail although there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
