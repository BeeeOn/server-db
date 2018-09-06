SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat queries/identities/fetch_by_email.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION identities_by_email(varchar)
RETURNS TABLE (
	id uuid,
	email varchar(250)
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM identities_by_email('example@example.org') $$,
	'there is nothing yet in the identities table'
);

SELECT finish();
ROLLBACK;
