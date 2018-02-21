SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat _api/verified_identities.fetch_by_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION verified_identities_by_id(uuid)
RETURNS TABLE (
	id uuid,
	identity_id uuid,
	user_id uuid,
	provider varchar(250),
	picture varchar(250),
	access_token varchar(250),
	identity_email varchar(250),
	user_first_name varchar(250),
	user_last_name varchar(250),
	user_locale varchar(32)
) AS :query LANGUAGE SQL;

SELECT plan(3);

SELECT is_empty(
	$$ SELECT * FROM verified_identities_by_id('17d49c4b-3515-400d-8f56-e893e592e0c2') $$,
	'there is nothing yet in the verified_identities table'
);

INSERT INTO identities (id, email)
VALUES
	('ef71fa06-ae06-41b9-9328-ecaf36035587', 'franta@example.org'),
	('805b014a-1ea6-441b-acd6-665b67d3243f', 'joe@example.org');

INSERT INTO users (id, first_name, last_name, locale)
VALUES
	('67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9', 'Franta', 'Bubak', 'cs_CZ'),
	('9a739ede-bb60-4e99-a20f-1d9fa8e7812d', 'Joe', 'Smith', 'en_GB');

INSERT INTO verified_identities (id, identity_id, user_id, provider, picture, access_token)
VALUES
	-- Franta Bubak, franta@example.org
	(
	 	'83a57444-e193-4ba4-8ab4-c519579f7ed0',
		'ef71fa06-ae06-41b9-9328-ecaf36035587',
		'67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9',
		'testing',
		NULL,
		NULL
	),
	-- Joe Smith, joe@example.org
	(
	 	'9a3f15e4-0506-44c9-8485-d7f02e4e1f63',
		'805b014a-1ea6-441b-acd6-665b67d3243f',
		'9a739ede-bb60-4e99-a20f-1d9fa8e7812d',
		'testing',
		NULL,
		NULL
	);

SELECT results_eq(
	$$ SELECT id, provider FROM verified_identities_by_id('83a57444-e193-4ba4-8ab4-c519579f7ed0') $$,
	$$ VALUES
		('83a57444-e193-4ba4-8ab4-c519579f7ed0'::uuid, 'testing'::varchar(250))
	$$,
	'Franta Bubak should have 1 verified identity'
);

SELECT results_eq(
	$$ SELECT id, provider FROM verified_identities_by_id('9a3f15e4-0506-44c9-8485-d7f02e4e1f63') $$,
	$$ VALUES
		('9a3f15e4-0506-44c9-8485-d7f02e4e1f63'::uuid, 'testing'::varchar(250))
	$$,
	'Joe Smith should have 1 verified identity'
);

SELECT finish();
ROLLBACK;
