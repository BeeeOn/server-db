SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat pgsql/identities/remove.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION identities_remove(uuid)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(5);

SELECT ok(NOT EXISTS(
	SELECT 1 FROM beeeon.identities
	WHERE id = '99da6e3b-8444-429b-a61c-235f303f566d'
	),
	'assure that identity of ID 99da6e3b-8444-429b-a61c-235f303f566d does not exist'
);

SELECT lives_ok(
	$$ SELECT identities_remove('99da6e3b-8444-429b-a61c-235f303f566d') $$,
	'no reason to fail on constraints'
);

INSERT INTO identities (id, email)
VALUES ('99da6e3b-8444-429b-a61c-235f303f566d', 'test@example.org');

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.identities
	WHERE id = '99da6e3b-8444-429b-a61c-235f303f566d'
	),
	'assure that identity of ID 99da6e3b-8444-429b-a61c-235f303f566d does exist'
);

SELECT lives_ok(
	$$ SELECT identities_remove('99da6e3b-8444-429b-a61c-235f303f566d') $$,
	'remove of identity 99da6e3b-8444-429b-a61c-235f303f566d should succeed'
);

SELECT ok(NOT EXISTS(
	SELECT 1 FROM beeeon.identities
	WHERE
		id = '99da6e3b-8444-429b-a61c-235f303f566d'
	),
	'identity of ID 99da6e3b-8444-429b-a61c-235f303f566d should have been removed'
);

SELECT finish();
ROLLBACK;
