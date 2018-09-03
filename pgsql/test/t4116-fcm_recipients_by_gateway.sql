SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat queries/fcm_recipients/by_gateway.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION fcm_recipients_by_gateway(bigint)
RETURNS TABLE (
	token varchar(250),
	user_id uuid,
	user_first_name varchar(250),
	user_last_name varchar(250),
	user_locale varchar(32)
) AS :query LANGUAGE SQL;

SELECT plan(4);

SELECT is_empty(
	$$ SELECT * FROM fcm_recipients_by_gateway(1240795450208837) $$,
	'must be empty, there is no gateway yet'
);

INSERT INTO beeeon.gateways (id, name, altitude, latitude, longitude, timezone)
VALUES
	(1115569803521760, 'first',  1, 1.5, -1.5, 'Europe/Paris'),
	(1942714939170667, 'second', 2, 2.5, -2.5, 'Europe/Prague'),
	(1149223136489871, 'third',  3, 3.5, -3.5, 'Europe/London');

INSERT INTO identities (id, email)
VALUES
	('18bc8fa5-7606-4964-b3e1-a3aa239b01d3', 'first@example.org'),
	('a21d5a10-7965-425f-93e1-ab8f7968cb34', 'second@example.org'),
	('75de0608-637e-441b-b47e-fdd800336139', 'third@example.org');

INSERT INTO users (id, first_name, last_name, locale)
VALUES
	('608aad61-5665-482a-918d-098a35602520', 'Franta', 'Bubak', 'cs_CZ'),
	('795b90c1-86b1-4ed7-a33f-b7f680c5f1db', 'Pepík', 'Dvořák', 'en_GB');

INSERT INTO verified_identities (id, identity_id, user_id, provider, picture, access_token)
VALUES ( -- Franta Bubak: first@example.org
	'd67d71d1-cbc4-40cc-ae47-eb28b9413f22',
	'18bc8fa5-7606-4964-b3e1-a3aa239b01d3',
	'608aad61-5665-482a-918d-098a35602520',
	'any',
	NULL,
	NULL
), ( -- Franta Bubak: second@example.org
	'712faa08-9ecd-4928-9ef1-cb280105a137',
	'a21d5a10-7965-425f-93e1-ab8f7968cb34',
	'608aad61-5665-482a-918d-098a35602520',
	'any-other',
	NULL,
	NULL
), ( -- Pepík Dvořák: third@example.org
	'96bac348-c2de-4702-a956-3ca1409c1afb',
	'75de0608-637e-441b-b47e-fdd800336139',
	'795b90c1-86b1-4ed7-a33f-b7f680c5f1db',
	'any',
	NULL,
	NULL
);

INSERT INTO roles_in_gateway (id, gateway_id, identity_id, level, created)
VALUES ( -- owner of gateway 1115569803521760 is Franta Bubak via first@example.org
	'4d1292ff-c02a-4ea6-a0e9-2e17028ff0a1',
	1115569803521760,
	'18bc8fa5-7606-4964-b3e1-a3aa239b01d3',
	10::smallint,
	beeeon.as_utc_timestamp(1511976414)
), ( -- user of gateway 1115569803521760 is Pepík Dvořák via third@example.org
	'9cf8d1d9-0c28-4df0-9023-6497f0a6f714',
	1115569803521760,
	'75de0608-637e-441b-b47e-fdd800336139',
	20::smallint,
	beeeon.as_utc_timestamp(1511976500)
), ( -- owner of gateway 1942714939170667 is Pepík Dvořák via third@example.org
	'7f4a4da6-bccf-48e2-a66b-df12bac2edcb',
	1942714939170667,
	'75de0608-637e-441b-b47e-fdd800336139',
	10::smallint,
	beeeon.as_utc_timestamp(1511976584)
);

INSERT INTO fcm_tokens (token, user_id)
VALUES ( -- Franta Bubak token 1
	'token1xxxxx',
	'608aad61-5665-482a-918d-098a35602520'
), ( -- Franta Bubak token 2
	'token2xxxxx',
	'608aad61-5665-482a-918d-098a35602520'
), ( -- Pepík Dvořák token 3
	'token3xxxxx',
	'795b90c1-86b1-4ed7-a33f-b7f680c5f1db'
);

SELECT results_eq(
	$$ SELECT token, user_id FROM fcm_recipients_by_gateway(1115569803521760) $$,
	$$ VALUES (
		'token1xxxxx'::varchar(250),
		'608aad61-5665-482a-918d-098a35602520'::uuid
	), (
		'token2xxxxx'::varchar(250),
		'608aad61-5665-482a-918d-098a35602520'::uuid
	), (
		'token3xxxxx'::varchar(250),
		'795b90c1-86b1-4ed7-a33f-b7f680c5f1db'::uuid
	) $$,
	'gateway 1115569803521760 should have 3 recipients'
);

SELECT results_eq(
	$$ SELECT token, user_id FROM fcm_recipients_by_gateway(1942714939170667) $$,
	$$ VALUES (
		'token3xxxxx'::varchar(250),
		'795b90c1-86b1-4ed7-a33f-b7f680c5f1db'::uuid
	) $$,
	'gateway 1942714939170667 should have only 1 recipient'
);

SELECT is_empty(
	$$ SELECT * FROM fcm_recipients_by_gateway(1149223136489871) $$,
	'nobody is assigned with gateway 1149223136489871'
);

SELECT finish();
ROLLBACK;
