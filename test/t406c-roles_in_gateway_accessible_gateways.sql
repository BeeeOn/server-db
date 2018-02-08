SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ '`cat _api/roles_in_gateway.fetch.accessible.gateways.sql`' $$'

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_accessible_gateways(integer, uuid)
RETURNS SETOF beeeon.gateway_with_status AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM roles_in_gateway_accessible_gateways(10, 'b6c168de-32c0-45a9-b23e-c936ac217ef1') $$,
	'there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
