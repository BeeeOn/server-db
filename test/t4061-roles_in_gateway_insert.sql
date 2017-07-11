SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(4);

SELECT has_function('roles_in_gateway_insert');

SELECT throws_ok(
	$$ SELECT roles_in_gateway_insert(
		'35a6c2ce-27a4-4d24-b787-3d6c8ac0877a',
		1589057876756829,
		'18bc8fa5-7606-4964-b3e1-a3aa239b01d3',
		10,
		extract(epoch FROM timestamp with time zone '2017-7-11 14:41:34')::bigint
	) $$,
	23503,
	NULL,
	'missing gateway 1589057876756829 and identity 18bc8fa5-7606-4964-b3e1-a3aa239b01d3'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (1589057876756829, 'MyHome', 0, 0, 0);

INSERT INTO identities (id, email)
VALUES ('18bc8fa5-7606-4964-b3e1-a3aa239b01d3', 'example@example.org');

SELECT lives_ok(
	$$ SELECT roles_in_gateway_insert(
		'35a6c2ce-27a4-4d24-b787-3d6c8ac0877a',
		1589057876756829,
		'18bc8fa5-7606-4964-b3e1-a3aa239b01d3',
		10,
		extract(epoch FROM timestamp with time zone '2017-7-11 14:41:34')::bigint
	) $$,
	'insert has no reason to fail now'
);

SELECT ok(EXISTS(
	SELECT 1 FROM roles_in_gateway
	WHERE
		id = '35a6c2ce-27a4-4d24-b787-3d6c8ac0877a'
		AND
		gateway_id = 1589057876756829
		AND
		identity_id = '18bc8fa5-7606-4964-b3e1-a3aa239b01d3'
		AND
		level = 10
		AND
		created = timestamp with time zone '2017-7-11 14:41:34'
	),
	'role 35a6c2ce-27a4-4d24-b787-3d6c8ac0877a should exist'
);

SELECT finish();
ROLLBACK;
