SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(5);

SELECT has_function('devices_insert');

SELECT throws_ok(
	$$ SELECT devices_insert(
		11678152912333531136::numeric(20, 0),
		1240795450208837,
		'56ffcd4a-49f3-406f-a452-e0c734f4ed8a',
		'test device',
		0::smallint,
		30,
		100::smallint,
		100::smallint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		NULL::bigint
	) $$,
	23503,
	NULL,
	'no such gateway and location exists'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (1240795450208837, 'testing gateway', 0, 0.0, 0.0);

SELECT throws_ok(
	$$ SELECT devices_insert(
		11678152912333531136::numeric(20, 0),
		1240795450208837,
		'56ffcd4a-49f3-406f-a452-e0c734f4ed8a',
		'test device',
		0::smallint,
		30,
		100::smallint,
		100::smallint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		NULL::bigint
	) $$,
	23503,
	NULL,
	'no such location exists'
);

INSERT INTO locations (id, name)
VALUES ('56ffcd4a-49f3-406f-a452-e0c734f4ed8a', 'testing location');

SELECT lives_ok(
	$$ SELECT devices_insert(
		11678152912333531136::numeric(20, 0),
		1240795450208837,
		'56ffcd4a-49f3-406f-a452-e0c734f4ed8a',
		'test device',
		0::smallint,
		30,
		100::smallint,
		100::smallint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		extract(epoch from timestamp '2017-7-14 08:55:16')::bigint,
		NULL::bigint
	) $$,
	'no constraints should fail'
);

SELECT is(id, -6768591161376020480::bigint) FROM devices LIMIT 1;

SELECT finish();
ROLLBACK;
