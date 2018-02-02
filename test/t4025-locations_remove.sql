SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/locations.remove.sql`

BEGIN;

PREPARE locations_remove(uuid)
AS :query;

SELECT plan(1);

SELECT lives_ok(
	$$ EXECUTE locations_remove('53e14bba-31d2-4819-8cfb-591caaf89d06') $$,
	'removing of non-existing location should not fail'
);

SELECT finish();
ROLLBACK;
