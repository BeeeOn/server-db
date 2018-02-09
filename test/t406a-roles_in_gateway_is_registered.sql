SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ '`cat _api/roles_in_gateway.is_registered.sql`' $$'

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_is_registered(bigint)
RETURNS boolean AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT ok(
	NOT roles_in_gateway_is_registered(1240795450208837),
	'cannot be true as there is no data in roles_in_gateway'
);

SELECT finish();
ROLLBACK;
