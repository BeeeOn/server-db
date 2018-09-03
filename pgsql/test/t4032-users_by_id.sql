SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat queries/users/fetch_by_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION users_by_id(uuid)
RETURNS TABLE (
	id uuid,
	first_name varchar(250),
	last_name varchar(250),
	locale varchar(32)
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM users_by_id('8c3e5613-7692-4915-951d-68362505e4ce') $$,
	'must be empty, there is no user yet'
);

SELECT finish();
ROLLBACK;
