SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat _api/verified_identities.update.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION verified_identities_update(uuid, varchar, varchar)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(1);

SELECT ok(
	NOT verified_identities_update('3d865c6e-0408-463e-9ae1-c90a93689a08', 'url-to-picture', 'a-token'),
	'nothing to update, expect false'
);

SELECT finish();
ROLLBACK;
