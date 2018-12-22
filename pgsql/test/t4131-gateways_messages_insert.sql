SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat queries/gateways_messages/insert.sql`

BEGIN;

PREPARE gateways_messages_insert(
	uuid, bigint, bigint, smallint, varchar(64), text, bigint)
AS :query;

SELECT plan(18);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (
	1509106553732838,
	'MyHome',
	0,
	0.0,
	0.0
);

SELECT lives_ok(
	$$ EXECUTE gateways_messages_insert(
		'd38698f8-2d66-4503-aa72-daf676b4479b',
		1509106553732838,
		1545498561000000,
		0,
		'failed-discover',
		'{"reason": "missing dongle"}',
		3)
	$$,
	'message should have been inserted'
);

SELECT is(COUNT(*), 1::bigint) FROM beeeon.gateways_messages;

SELECT ok(EXISTS(
	SELECT 1 FROM beeeon.gateways_messages
	WHERE
		id = 'd38698f8-2d66-4503-aa72-daf676b4479b'
	),
	'message d38698f8-2d66-4503-aa72-daf676b4479b must be there'
);

SELECT lives_ok(
	$$ EXECUTE gateways_messages_insert(
		'963147c3-f32b-43be-a314-776c7f52864e',
		1509106553732838,
		1545498720000000,
		1,
		'device-unavailable',
		NULL,
		3)
	$$,
	'message should have been inserted'
);

SELECT is(COUNT(*), 2::bigint) FROM beeeon.gateways_messages;

SELECT results_eq(
	$$ SELECT id FROM beeeon.gateways_messages ORDER BY at $$,
	$$ VALUES
		('d38698f8-2d66-4503-aa72-daf676b4479b'::uuid),
		('963147c3-f32b-43be-a314-776c7f52864e'::uuid)
	$$,
	'2 messages must be there'
);

SELECT lives_ok(
	$$ EXECUTE gateways_messages_insert(
		'f34848df-fa53-47d0-bf97-e80cfe48f018',
		1509106553732838,
		1545499006000000,
		2,
		'everything-works',
		NULL,
		3)
	$$,
	'message should have been inserted'
);

SELECT is(COUNT(*), 3::bigint) FROM beeeon.gateways_messages;

SELECT results_eq(
	$$ SELECT id FROM beeeon.gateways_messages ORDER BY at $$,
	$$ VALUES
		('d38698f8-2d66-4503-aa72-daf676b4479b'::uuid),
		('963147c3-f32b-43be-a314-776c7f52864e'::uuid),
		('f34848df-fa53-47d0-bf97-e80cfe48f018'::uuid)
	$$,
	'3 messages must be there'
);

SELECT throws_ok(
	$$ EXECUTE gateways_messages_insert(
		'16c30aaa-1fb4-4e34-8fc1-c0fd74714a27',
		1509106553732838,
		1545499006000000,
		2,
		'everything-works',
		NULL,
		3)
	$$,
	23505,
	NULL,
	'duplicate timestamp, severity and key for gateway 1509106553732838'
);

SELECT is(COUNT(*), 3::bigint) FROM beeeon.gateways_messages;

SELECT results_eq(
	$$ SELECT id FROM beeeon.gateways_messages ORDER BY at $$,
	$$ VALUES
		('d38698f8-2d66-4503-aa72-daf676b4479b'::uuid),
		('963147c3-f32b-43be-a314-776c7f52864e'::uuid),
		('f34848df-fa53-47d0-bf97-e80cfe48f018'::uuid)
	$$,
	'3 messages must still be there'
);

SELECT lives_ok(
	$$ EXECUTE gateways_messages_insert(
		'ae4d45f1-bfba-4f01-880b-8605ecd5b928',
		1509106553732838,
		1545499303000000,
		1,
		'gateway-is-reconnecting',
		'{"count": 500}',
		3)
	$$,
	'message should have been inserted'
);

SELECT is(COUNT(*), 3::bigint) FROM beeeon.gateways_messages;

SELECT results_eq(
	$$ SELECT id FROM beeeon.gateways_messages ORDER BY at $$,
	$$ VALUES
		('963147c3-f32b-43be-a314-776c7f52864e'::uuid),
		('f34848df-fa53-47d0-bf97-e80cfe48f018'::uuid),
		('ae4d45f1-bfba-4f01-880b-8605ecd5b928'::uuid)
	$$,
	'3 messages must be there, but rotated'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (
	1296276644144432,
	'MyWork',
	0,
	0.0,
	0.0
);

SELECT lives_ok(
	$$ EXECUTE gateways_messages_insert(
		'939b55ac-abb4-4a14-a6cc-8f9ada440fb4',
		1296276644144432,
		1545499303000000,
		1,
		'gateway-is-reconnecting',
		'{"count": 500}',
		3)
	$$,
	'message should have been inserted, another gateway'
);

SELECT is(COUNT(*), 4::bigint) FROM beeeon.gateways_messages;

SELECT results_eq(
	$$ SELECT id FROM beeeon.gateways_messages ORDER BY at, id $$,
	$$ VALUES
		('963147c3-f32b-43be-a314-776c7f52864e'::uuid),
		('f34848df-fa53-47d0-bf97-e80cfe48f018'::uuid),
		('939b55ac-abb4-4a14-a6cc-8f9ada440fb4'::uuid), -- new one
		('ae4d45f1-bfba-4f01-880b-8605ecd5b928'::uuid)
	$$,
	'4 messages must be there, one for another gateway'
);

SELECT finish();
ROLLBACK;
