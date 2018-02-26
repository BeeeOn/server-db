SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat pgsql/identities/fetch_by_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION identities_by_id(uuid)
RETURNS TABLE (
	id uuid,
	email varchar(250)
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM identities_by_id('b6c168de-32c0-45a9-b23e-c936ac217ef1') $$,
	'there is nothing yet in the identities table'
);

SELECT finish();
ROLLBACK;
