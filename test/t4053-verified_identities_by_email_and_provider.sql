SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/verified_identities.fetch_by_email_and_provider.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION verified_identities_by_email_and_provider(varchar, varchar)
RETURNS SETOF beeeon.verified_identity AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM verified_identities_by_email_and_provider('example@example.org', 'testing') $$,
	'there are no verified identities yet'
);

SELECT finish();
ROLLBACK;
