SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(5);

SELECT has_function('roles_in_gateway_can_see_identity');

SELECT ok(
	NOT beeeon.roles_in_gateway_can_see_identity(
		'18bc8fa5-7606-4964-b3e1-a3aa239b01d3',
		'35a6c2ce-27a4-4d24-b787-3d6c8ac0877a'
	),
	'user 35a6c2ce-27a4-4d24-b787-3d6c8ac0877a must not see identity 18bc8fa5-7606-4964-b3e1-a3aa239b01d3'
);

INSERT INTO gateways (id, name)
VALUES
(
	12309123784230,
	'testing gateway'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES
(
	'ee799206-8c44-4e00-b88b-4be3b8ede082',
	'John',
	'Smith',
	''
);

INSERT INTO identities (id, email)
VALUES
(
	'12f2c1b9-737a-4c30-885a-f98f2e8aaa55',
	'somebody@example.org'
),
(
	'c1eb4425-278d-479f-ac6c-ede1c38931e2',
	'john.smith@example.org'
),
(
	'e6f59816-beac-4dcd-9c27-7d2d49b5f0ca',
	'invisible@example.org'
);

INSERT INTO verified_identities (id, identity_id, user_id, provider)
VALUES
-- John Smith
(
	'1b11114e-b216-4b97-8a0e-97b5ab6da659',
	'c1eb4425-278d-479f-ac6c-ede1c38931e2',
	'ee799206-8c44-4e00-b88b-4be3b8ede082',
	'testing-provider'
);

INSERT INTO roles_in_gateway (id, gateway_id, identity_id, level, created)
VALUES
-- somebody@example.org can access gateway 12309123784230
(
	'29ad4954-fc4e-4a6e-9a35-08a358f4f549',
	12309123784230,
	'12f2c1b9-737a-4c30-885a-f98f2e8aaa55',
	20,
	NOW()
),
-- John Smith can access gateway 12309123784230
(
	'ba65ad96-7f34-492b-beef-84a03632a61c',
	12309123784230,
	'c1eb4425-278d-479f-ac6c-ede1c38931e2',
	20,
	NOW() + interval '1 second'
);

SELECT ok(
	beeeon.roles_in_gateway_can_see_identity(
		'12f2c1b9-737a-4c30-885a-f98f2e8aaa55',
		'ee799206-8c44-4e00-b88b-4be3b8ede082'
	),
	'user ee799206-8c44-4e00-b88b-4be3b8ede082 must see identity 12f2c1b9-737a-4c30-885a-f98f2e8aaa55'
);

SELECT ok(
	NOT beeeon.roles_in_gateway_can_see_identity(
		'e6f59816-beac-4dcd-9c27-7d2d49b5f0ca',
		'ee799206-8c44-4e00-b88b-4be3b8ede082'
	),
	'user ee799206-8c44-4e00-b88b-4be3b8ede082 must not see identity e6f59816-beac-4dcd-9c27-7d2d49b5f0ca'
);

SELECT ok(
	beeeon.roles_in_gateway_can_see_identity(
		'c1eb4425-278d-479f-ac6c-ede1c38931e2',
		'ee799206-8c44-4e00-b88b-4be3b8ede082'
	),
	'user ee799206-8c44-4e00-b88b-4be3b8ede082 must see herself'
);

SELECT finish();
ROLLBACK;
