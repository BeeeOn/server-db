SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(4);

SELECT has_function('gateways_accessible');

SELECT ok(
	NOT EXISTS(
		SELECT gateways_accessible('d2cc524a-a9ab-4f91-9b2e-aa67399a5485')
	),
	'no such user and anything, so no result is expected'
);
--
---
-- Create gateways and users with a permissions assignment.
--
-- User             E-mail                  Gateway
-- Franta Novak     franta1@example.org     first
-- Franta Novak     franta2@example.org     second
-- Michael Jackson  michael3@example.org    third
---
INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES
	(1635070073611451, 'first', 0, 0, 0),
	(1636174971032851, 'second', 1, 1, 1),
	(1559186554322495, 'third', 2, 2, 2);

INSERT INTO identities (id, email)
VALUES
	('0d4fcca8-4861-4f4f-8b30-1607ff798e69', 'franta1@example.org'),
	('fa64cae2-5e88-4f02-812c-6f7b38410a38', 'franta2@example.org'),
	('c65551cf-acd8-46f6-8445-52788c969e8f', 'michael3@example.org');

INSERT INTO users (id, first_name, last_name, locale)
VALUES
	('33cafeac-8dc8-4306-a88d-0c04b75236a8', 'Franta', 'Novak', 'cs_CZ'),
	('0a67774c-6256-4e72-bd8b-a2e3521fb3ba', 'Michael', 'Jackson', 'en_US');

INSERT INTO verified_identities (id, identity_id, user_id, provider, picture, access_token)
VALUES
	('92c0c3e4-539f-4f2d-b3cf-731bcfcfea44', '0d4fcca8-4861-4f4f-8b30-1607ff798e69', '33cafeac-8dc8-4306-a88d-0c04b75236a8', 'testing', NULL, NULL),
	('5b1bfc37-4d0e-4af6-900a-6b1a00da453b', 'fa64cae2-5e88-4f02-812c-6f7b38410a38', '33cafeac-8dc8-4306-a88d-0c04b75236a8', 'testing', NULL, NULL),
	('f7020961-a6dd-45db-87bb-d0890d96ec8f', 'c65551cf-acd8-46f6-8445-52788c969e8f', '0a67774c-6256-4e72-bd8b-a2e3521fb3ba', 'testing', NULL, NULL);

INSERT INTO roles_in_gateway (id, gateway_id, identity_id, level, created)
VALUES
	('0558ce78-a082-4f31-89f7-295526ab9d81', 1635070073611451, '0d4fcca8-4861-4f4f-8b30-1607ff798e69', 10, as_utc_timestamp(1499662971)),
	('602a177a-42eb-4076-802e-d5e5271c61ac', 1636174971032851, 'fa64cae2-5e88-4f02-812c-6f7b38410a38', 10, as_utc_timestamp(1499681673)),
	('f4cf520b-128a-43aa-a4a5-dd02b53c7701', 1559186554322495, 'c65551cf-acd8-46f6-8445-52788c969e8f', 10, as_utc_timestamp(1499675520));

SELECT results_eq(
	$$ SELECT id, name FROM gateways_accessible('33cafeac-8dc8-4306-a88d-0c04b75236a8') ORDER BY id $$,
	$$ VALUES 
		(1635070073611451::bigint, 'first'::varchar(250)),
		(1636174971032851::bigint, 'second'::varchar(250))
	$$,
	'Franta Novak can access gateways 1635070073611451 and 1636174971032851'
);

SELECT results_eq(
	$$ SELECT id, name FROM gateways_accessible('0a67774c-6256-4e72-bd8b-a2e3521fb3ba') ORDER BY id $$,
	$$ VALUES
		(1559186554322495::bigint, 'third'::varchar(250))
	$$,
	'Michael Jackson can access gateway 1559186554322495'
);

SELECT finish();
ROLLBACK;
