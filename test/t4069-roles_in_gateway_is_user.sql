SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ '`cat _api/roles_in_gateway.is.user.sql`' $$'

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_is_user(uuid, uuid)
RETURNS boolean AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT ok(
	NOT roles_in_gateway_is_user('35a6c2ce-27a4-4d24-b787-3d6c8ac0877a', '81b096c5-251c-4483-ac8b-e5577924115b'),
	'cannot be true as there is no data in roles_in_gateway'
);

SELECT finish();
ROLLBACK;
