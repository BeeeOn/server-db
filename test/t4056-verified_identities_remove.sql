SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/verified_identities/remove.sql`

BEGIN;

PREPARE verified_identities_remove(uuid)
AS :query;

SELECT plan(1);

SELECT lives_ok(
	$$ EXECUTE verified_identities_remove('35a6c2ce-27a4-4d24-b787-3d6c8ac0877a') $$,
	'removing of non-existing verified identity should not fail'
);

SELECT finish();
ROLLBACK;
