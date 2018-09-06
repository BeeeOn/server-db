SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat queries/identities/create.sql`

BEGIN;

PREPARE identities_insert(uuid, varchar)
AS :query;

SELECT plan(5);

SELECT lives_ok(
	$$ EXECUTE identities_insert('99da6e3b-8444-429b-a61c-235f303f566d', 'example@example.org') $$,
	'no reason to fail on constraints'
);

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.identities
	WHERE
		id = '99da6e3b-8444-429b-a61c-235f303f566d'
		AND
		email = 'example@example.org'
	),
	'identity of ID 99da6e3b-8444-429b-a61c-235f303f566d should have been inserted'
);

SELECT throws_ok(
	$$ EXECUTE identities_insert('99da6e3b-8444-429b-a61c-235f303f566d', 'any@any.org') $$,
	23505,
	NULL,
	'primary key violation when creating the same identity twice'
);

SELECT throws_ok(
	$$ EXECUTE identities_insert('ba57d5de-241a-432e-a5ce-3abdbaa6e88b', 'example@example.org') $$,
	23505,
	NULL,
	'unique check violation when creating identity with an existing e-mail'
);

SELECT throws_ok(
	$$ EXECUTE identities_insert('ac200f2d-a4cc-4363-9e48-200c9f7a9339', 'malformed') $$,
	23514,
	NULL,
	'e-mail check violation'
);

SELECT finish();
ROLLBACK;
