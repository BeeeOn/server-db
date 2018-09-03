SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat queries/verified_identities/create.sql`

BEGIN;

PREPARE verified_identities_insert(
	uuid, uuid, uuid, varchar, varchar, varchar)
AS :query;

SELECT plan(6);

SELECT throws_ok(
	$$ EXECUTE verified_identities_insert(
		'68445d80-9d7b-490d-b3b2-e9b4876be8c9',
		'4f64fb33-056d-430f-8a8d-e66016ac473d',
		'608aad61-5665-482a-918d-098a35602520',
		'testing',
		NULL,
		NULL
	) $$,
	23503,
	NULL,
	'no such user nor identity'
);

INSERT INTO identities (id, email)
VALUES ('4f64fb33-056d-430f-8a8d-e66016ac473d', 'test@example.org');

SELECT throws_ok(
	$$ EXECUTE verified_identities_insert(
		'68445d80-9d7b-490d-b3b2-e9b4876be8c9',
		'4f64fb33-056d-430f-8a8d-e66016ac473d',
		'608aad61-5665-482a-918d-098a35602520',
		'testing',
		NULL,
		NULL
	) $$,
	23503,
	NULL,
	'no such user'
);

DELETE FROM identities WHERE id = '4f64fb33-056d-430f-8a8d-e66016ac473d';

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ');

SELECT throws_ok(
	$$ EXECUTE verified_identities_insert(
		'68445d80-9d7b-490d-b3b2-e9b4876be8c9',
		'4f64fb33-056d-430f-8a8d-e66016ac473d',
		'608aad61-5665-482a-918d-098a35602520',
		'testing',
		NULL,
		NULL
	) $$,
	23503,
	NULL,
	'no such identity'
);

INSERT INTO identities (id, email)
VALUES ('4f64fb33-056d-430f-8a8d-e66016ac473d', 'test@example.org');

SELECT lives_ok(
	$$ EXECUTE verified_identities_insert(
		'68445d80-9d7b-490d-b3b2-e9b4876be8c9',
		'4f64fb33-056d-430f-8a8d-e66016ac473d',
		'608aad61-5665-482a-918d-098a35602520',
		'testing',
		NULL,
		NULL
	) $$,
	'no reason to fail on constraints'
);

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.verified_identities
	WHERE
		id = '68445d80-9d7b-490d-b3b2-e9b4876be8c9'
		AND
		identity_id = '4f64fb33-056d-430f-8a8d-e66016ac473d'
		AND
		user_id = '608aad61-5665-482a-918d-098a35602520'
		AND
		provider = 'testing'
		AND
		picture IS NULL
		AND
		access_token IS NULL
	),
	'identity of ID 68445d80-9d7b-490d-b3b2-e9b4876be8c9 should have been inserted'
);

SELECT throws_ok(
	$$ EXECUTE verified_identities_insert(
		'68445d80-9d7b-490d-b3b2-e9b4876be8c9',
		'4f64fb33-056d-430f-8a8d-e66016ac473d',
		'608aad61-5665-482a-918d-098a35602520',
		'testing',
		NULL,
		NULL
	) $$,
	23505,
	NULL,
	'primary key violation when creating the same identity twice'
);

SELECT finish();
ROLLBACK;
