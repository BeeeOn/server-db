SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat pgsql/locations/update.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION locations_update(uuid, varchar)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(1);

SELECT ok(
	NOT locations_update('fad5baf1-3bd8-4f7f-a06e-137ffb4ef924', 'Kitchen')
);

SELECT finish();
ROLLBACK;
