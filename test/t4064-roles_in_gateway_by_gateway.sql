SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/roles_in_gateway.fetch.by.gateway_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_by_gateway(bigint)
RETURNS SETOF beeeon.role_in_gateway AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM roles_in_gateway_by_gateway(1240795450208837) $$,
	'there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
