SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat pgsql/devices/remove_unused.sql`

BEGIN;

PREPARE devices_remove_unused AS :query;

SELECT plan(7);

SELECT is(COUNT(*), 0::bigint) FROM devices;

-- delete from epty table works
SELECT lives_ok('devices_remove_unused');
SELECT is(COUNT(*), 0::bigint) FROM devices;

INSERT INTO gateways (
	id,
	name
)
VALUES (
	1240795450208837::bigint,
	'testing gateway'
);

---
-- Create 5 devices, 3 of them are not considered unused because
-- they are either active or has history.
---
INSERT INTO devices (
	id,
	gateway_id,
	name,
	type,
	first_seen,
	last_seen,
	active_since
)
VALUES (
	to_device_id(11678152912333531136::numeric(20, 0)),
	1240795450208837::bigint,
	'active device with data',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22',
	timestamp '2017-7-20 10:02:02'
), (
	to_device_id(11678152912333531137::numeric(20, 0)),
	1240795450208837::bigint,
	'active device without data',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22',
	timestamp '2017-7-20 10:02:02'

), (
	to_device_id(11678152912333531138::numeric(20, 0)),
	1240795450208837::bigint,
	'inactive device with data',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22',
	NULL
), (
	to_device_id(11678152912333531139::numeric(20, 0)),
	1240795450208837::bigint,
	'removable first inactive device without data',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22',
	NULL
), (
	to_device_id(11678152912333531140::numeric(20, 0)),
	1240795450208837::bigint,
	'removable second inactive device without data',
	0,
	timestamp '2017-7-20 10:01:01',
	timestamp '2017-7-20 22:22:22',
	NULL
);

---
-- There are 5 devices after inserting testing data.
---
SELECT is(COUNT(*), 5::bigint) FROM devices;

---
-- Insert some data for devices with data.
---
INSERT INTO beeeon.sensor_history VALUES (
	1240795450208837::bigint,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	timestamp '2017-7-20 10:02:02',
	15.5
), (
	1240795450208837::bigint,
	to_device_id(11678152912333531138::numeric(20, 0)),
	0,
	timestamp '2017-7-20 10:01:01',
	20
);

---
-- Remove the 2 unused devices.
---
SELECT lives_ok('devices_remove_unused');

---
-- There are 3 devices after the removal.
---
SELECT is(COUNT(*), 3::bigint) FROM devices;

SELECT results_eq(
	$$ SELECT name, from_device_id(id)::numeric(20, 0) FROM devices ORDER BY id $$,
	$$ VALUES (
		'active device with data'::varchar,
		11678152912333531136::numeric(20, 0)
	), (
		'active device without data'::varchar,
		11678152912333531137::numeric(20, 0)
	), (
		'inactive device with data'::varchar,
		11678152912333531138::numeric(20, 0)
	) $$,
	'only removable devices should remain'
);

SELECT finish();
ROLLBACK;
