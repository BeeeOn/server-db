SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat pgsql/roles_in_gateway/fetch_by_gateway_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION roles_in_gateway_by_gateway(bigint)
RETURNS TABLE (
	id uuid,
	gateway_id bigint,
	identity_id uuid,
	level smallint,
	created bigint,
	identity_email varchar(250)
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM roles_in_gateway_by_gateway(1240795450208837) $$,
	'there is nothing yet in the roles_in_gateway table'
);

SELECT finish();
ROLLBACK;
