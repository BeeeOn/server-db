SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat pgsql/verified_identities/fetch_by_user.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION verified_identities_by_user(uuid)
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
	$$ SELECT * FROM verified_identities_by_user('67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9') $$,
	'there is nothing yet in the verified_identities table'
);

INSERT INTO identities (id, email)
VALUES
	('ef71fa06-ae06-41b9-9328-ecaf36035587', 'franta1@example.org'),
	('805b014a-1ea6-441b-acd6-665b67d3243f', 'franta2@example.org'),
	('1d83ae31-100b-4fad-b873-bf7bea670b76', 'joe@example.org');

INSERT INTO users (id, first_name, last_name, locale)
VALUES
	('67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9', 'Franta', 'Bubak', 'cs_CZ'),
	('9a739ede-bb60-4e99-a20f-1d9fa8e7812d', 'Joe', 'Smith', 'en_GB');

INSERT INTO verified_identities (id, identity_id, user_id, provider, picture, access_token)
VALUES
	-- Franta Bubak, franta1@example.org, testing
	(
	 	'83a57444-e193-4ba4-8ab4-c519579f7ed0',
		'ef71fa06-ae06-41b9-9328-ecaf36035587',
		'67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9',
		'testing',
		NULL,
		NULL
	),
	-- Franta Bubak, franta1@example.org, 3rdparty
	(
	 	'9a3f15e4-0506-44c9-8485-d7f02e4e1f63',
		'ef71fa06-ae06-41b9-9328-ecaf36035587',
		'67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9',
		'3rdparty',
		NULL,
		NULL
	),
	-- Franta Bubak, franta2@example.org, testing
	(
	 	'40b53706-73ae-410f-bd69-3dce8db3d80c',
		'805b014a-1ea6-441b-acd6-665b67d3243f',
		'67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9',
		'testing',
		NULL,
		NULL
	),
	-- Joe Smith, joe@example.org, testing
	(
	 	'89275015-1732-42bb-a20f-73a9917685fd',
		'1d83ae31-100b-4fad-b873-bf7bea670b76',
		'9a739ede-bb60-4e99-a20f-1d9fa8e7812d',
		'testing',
		NULL,
		NULL
	);

SELECT results_eq(
	$$ SELECT id FROM verified_identities_by_user('67fedc4f-d7c1-41eb-af73-a9ba71f9a8c9') $$,
	$$ VALUES
		('9a3f15e4-0506-44c9-8485-d7f02e4e1f63'::uuid),
		('40b53706-73ae-410f-bd69-3dce8db3d80c'::uuid),
		('83a57444-e193-4ba4-8ab4-c519579f7ed0'::uuid)
	$$,
	'Franta Bubak has 3 verified identities in total'
);

SELECT results_eq(
	$$ SELECT id FROM verified_identities_by_user('9a739ede-bb60-4e99-a20f-1d9fa8e7812d') $$,
	$$ VALUES ('89275015-1732-42bb-a20f-73a9917685fd'::uuid) $$,
	'Joe Smith has 1 verified identity in total'
);

SELECT finish();
ROLLBACK;
