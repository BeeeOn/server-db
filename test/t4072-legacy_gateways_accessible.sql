SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/legacy_gateways.fetch.accessible.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION legacy_gateways_accessible(uuid)
RETURNS SETOF beeeon.legacy_gateway AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM legacy_gateways_accessible('56ffcd4a-49f3-406f-a452-e0c734f4ed8a') $$,
	'there is nothing yet in the gateways table'
);

SELECT finish();
ROLLBACK;
