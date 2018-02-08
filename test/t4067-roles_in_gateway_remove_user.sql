SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/roles_in_gateway.remove.user.sql`

BEGIN;

PREPARE roles_in_gateway_remove_user(uuid, bigint)
AS :query;

SELECT plan(1);

SELECT lives_ok(
	$$ EXECUTE roles_in_gateway_remove_user('83f42cf5-16e3-4fcb-b4f7-4426e738c779', 1537405487422784) $$,
	'there is no reason to fail on removing non-existing roles'
);

SELECT finish();
ROLLBACK;
