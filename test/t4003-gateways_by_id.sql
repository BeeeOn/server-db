SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(7);

SELECT has_function('gateways_by_id');

SELECT is_empty(
	$$ SELECT * FROM gateways_by_id(1240795450208837) $$,
	'there is nothing yet in the gateways table'
);

INSERT INTO beeeon.gateways (id, name, altitude, latitude, longitude, timezone)
VALUES
	(1115569803521760, 'first',  1, 1.5, -1.5, 'Europe/Paris'),
	(1942714939170667, 'second', 2, 2.5, -2.5, 'Europe/Prague'),
	(1149223136489871, 'third',  3, 3.5, -3.5, 'Europe/London');

SELECT results_eq(
	$$ SELECT * FROM gateways_by_id(1115569803521760) $$,
	$$ VALUES (
		1115569803521760,
		'first'::varchar(250),
		1,
		1.5::double precision,
		-1.5::double precision,
		'Europe/Paris'::varchar(64),
		NULL::bigint,
		NULL::varchar(40),
		NULL::varchar(45)
	) $$,
	'gateway of ID 1115569803521760 should have been created'
);

SELECT results_eq(
	$$ SELECT * FROM gateways_by_id(1942714939170667) $$,
	$$ VALUES (
		1942714939170667,
		'second'::varchar(250),
		2,
		2.5::double precision,
		-2.5::double precision,
		'Europe/Prague'::varchar(64),
		NULL::bigint,
		NULL::varchar(40),
		NULL::varchar(45)
	) $$,
	'gateway of ID 1942714939170667 should have been created'
);

SELECT results_eq(
	$$ SELECT * FROM gateways_by_id(1149223136489871) $$,
	$$ VALUES (
		1149223136489871,
		'third'::varchar(250),
		3,
		3.5::double precision,
		-3.5::double precision,
		'Europe/London'::varchar(64),
		NULL::bigint,
		NULL::varchar(40),
		NULL::varchar(45)
	) $$,
	'gateway of ID 1149223136489871 should have been created'
);

INSERT INTO gateways_status (gateway_id, at, version, ip)
VALUES
	(1115569803521760, timestamp with time zone '2017-7-9 22:57:12', 'master', '192.168.1.1'::inet),
	(1115569803521760, timestamp with time zone '2017-7-9 23:14:06', 'master', '192.168.1.2'::inet),
	(1149223136489871, timestamp with time zone '2017-7-10 18:08:43', 'other', '10.0.10.1'::inet),
	(1115569803521760, timestamp with time zone '2017-7-10 01:10:46', 'next', '192.168.1.2'::inet);

SELECT is(MAX(at), timestamp with time zone '2017-7-10 01:10:46')
	FROM gateways_status
	WHERE gateway_id = 1115569803521760;

SELECT results_eq(
	$$ SELECT * FROM gateways_by_id(1115569803521760) $$,
	$$ VALUES (
		1115569803521760,
		'first'::varchar(250),
		1,
		1.5::double precision,
		-1.5::double precision,
		'Europe/Paris'::varchar(64),
		extract(epoch FROM timestamp with time zone '2017-7-10 01:10:46')::bigint,
		'next'::varchar(40),
		'192.168.1.2'::varchar(45)
	) $$,
	'gateway of ID 1115569803521760 should have been created with status'
);

SELECT finish();
ROLLBACK;
