SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat queries/controls_fsm/mark_accepted.sql`; 'RETURN FOUND; END; $$'

BEGIN;

CREATE OR REPLACE FUNCTION mark_accepted(
	bigint, bigint, numeric(20, 0), integer, bigint)
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(6);

INSERT INTO beeeon.users VALUES (
	'e00c9284-2ec1-4c79-977e-0d7f82551ce5',
	'Franta',
	'Tester',
	'en_US'
);

INSERT INTO beeeon.gateways VALUES (
	1958208632862596,
	'Testing gateway',
	NULL,
	NULL,
	NULL
);

INSERT INTO beeeon.devices (
	id,
	gateway_id,
	name,
	type,
	first_seen,
	last_seen
) VALUES (
	beeeon.to_device_id(11678152912333531136),
	1958208632862596,
	'Testing device',
	1,
	timestamp '2018-11-10 15:42:59',
	timestamp '2018-11-12 05:07:14'
);

INSERT INTO beeeon.controls_fsm
VALUES (
	1958208632862596,
	beeeon.to_device_id(11678152912333531136),
	0,
	0.0,
	timestamp '2018-11-12 08:48:29',
	timestamp '2018-11-12 08:48:32',
	timestamp '2018-11-12 08:49:15',
	false,
	'e00c9284-2ec1-4c79-977e-0d7f82551ce5'
), (
	1958208632862596,
	beeeon.to_device_id(11678152912333531136),
	0,
	1.0,
	timestamp '2018-11-12 11:17:56',
	NULL,
	NULL,
	false,
	'e00c9284-2ec1-4c79-977e-0d7f82551ce5'
), (
	1958208632862596,
	beeeon.to_device_id(11678152912333531136),
	1,
	24.0,
	timestamp '2018-11-13 09:53:09',
	timestamp '2018-11-13 09:53:14',
	NULL,
	false,
	'e00c9284-2ec1-4c79-977e-0d7f82551ce5'
), (
	1958208632862596,
	beeeon.to_device_id(11678152912333531136),
	2,
	0.0,
	timestamp '2018-11-13 14:36:15',
	NULL,
	timestamp '2018-11-13 14:36:16',
	true,
	'e00c9284-2ec1-4c79-977e-0d7f82551ce5'
);

SELECT ok(mark_accepted(
	extract(epoch FROM timestamp '2018-11-12 11:17:59')::bigint * 1000000,
	1958208632862596,
	11678152912333531136::numeric(20, 0),
	0,
	extract(epoch FROM timestamp '2018-11-12 11:17:56')::bigint * 1000000
), 'should have been marked accepted after 3 seconds');

SELECT results_eq(
	$$
	SELECT accepted_at, finished_at
	FROM beeeon.controls_fsm
	WHERE
		requested_at = timestamp '2018-11-12 11:17:56'
	$$,
	$$ VALUES (
		timestamp '2018-11-12 11:17:59',
		NULL::timestamp
	) $$,
	'request was not accepted properly'
);

SELECT ok(NOT mark_accepted(
	extract(epoch FROM timestamp '2018-11-13 09:53:18')::bigint * 1000000,
	1958208632862596,
	11678152912333531136::numeric(20, 0),
	1,
	extract(epoch FROM timestamp '2018-11-13 09:53:09')::bigint * 1000000
), 'duplicate accept must fail');

SELECT results_eq(
	$$
	SELECT accepted_at, finished_at
	FROM beeeon.controls_fsm
	WHERE
		requested_at = timestamp '2018-11-13 09:53:09'
	$$,
	$$ VALUES (
		timestamp '2018-11-13 09:53:14',
		NULL::timestamp
	) $$,
	'request was accepted twice'
);

SELECT ok(NOT mark_accepted(
	extract(epoch FROM timestamp '2018-11-13 14:36:15.168')::bigint * 1000000,
	1958208632862596,
	11678152912333531136::numeric(20, 0),
	2,
	extract(epoch FROM timestamp '2018-11-13 14:36:15')::bigint * 1000000
), 'must not mark accepted when already finished');

SELECT results_eq(
	$$
	SELECT accepted_at, finished_at
	FROM beeeon.controls_fsm
	WHERE
		requested_at = timestamp '2018-11-13 14:36:15'
	$$,
	$$ VALUES (
		NULL::timestamp,
		timestamp '2018-11-13 14:36:16'
	) $$,
	'request was accepted after finished'
);

SELECT finish();
ROLLBACK;
