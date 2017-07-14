SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(4);

SELECT has_function('devices_update');

SELECT ok(
	NOT devices_update(
		11678152912333531136::numeric(20, 0),
		1240795450208837::bigint,
		'e7288b22-8990-4bac-a71b-836112bc3719'::uuid,
		'testing device',
		0::smallint,
		40,
		100::smallint,
		100::smallint,
		NULL::bigint
	),
	'there is nothing to update'
);

INSERT INTO gateways (
	id,
	name
)
VALUES (
	1240795450208837::bigint,
	'testing gateway'
);

INSERT INTO devices (
	id,
	gateway_id,
	name,
	type,
	first_seen,
	last_seen
)
VALUES (
	to_device_id(11678152912333531136::numeric(20, 0)),
	1240795450208837::bigint,
	'testing device',
	0,
	timestamp with time zone '2017-7-20 10:01:01',
	timestamp with time zone '2017-7-20 22:22:22'
);

SELECT ok(
	devices_update(
		11678152912333531136::numeric(20, 0),
		1240795450208837::bigint,
		NULL::uuid,
		'testing device 2',
		0::smallint,
		50,
		99::smallint,
		50::smallint,
		extract(epoch FROM timestamp with time zone '2017-7-20 23:23:23')::bigint
	),
	'update should work, device exists'
);

SELECT results_eq(
	$$
	SELECT
		name,
		refresh,
		battery,
		signal,
		last_seen > timestamp with time zone '2017-7-20 22:22:22',
		active_since
	FROM devices
	$$,
	$$ VALUES (
		'testing device 2'::varchar,
		50,
		99::smallint,
		50::smallint,
		true,
		timestamp with time zone '2017-7-20 23:23:23'
	) $$,
	'update of name, refresh, battery, signal, active_since and last_seen should work'
);

SELECT finish();
ROLLBACK;
