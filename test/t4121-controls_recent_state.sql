SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(6);

SELECT has_function('controls_recent_state');

SELECT ok(
	NOT EXISTS(
		SELECT * FROM controls_recent_state(1240795450208837, 11678152912333531136::numeric(20, 0), 0::smallint)
	),
	'no reason to fail'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('2bcf60a9-cd37-4f27-a7ab-3e6b740770ed', 'Joe', 'Doe', 'en');

INSERT INTO gateways (id, name)
VALUES (1240795450208837, 'testing gateway');

INSERT INTO devices (id, gateway_id, name, type, first_seen, last_seen)
VALUES
(
	to_device_id(11678152912333531136::numeric(20, 0)),
	1240795450208837,
	'testing device',
	0,
	timestamp with time zone '2017-10-1 8:00:00',
	timestamp with time zone '2017-10-4 9:00:00'
);

INSERT INTO controls_recent (gateway_id, device_id, module_id, value, at, stability, originator_user_id)
VALUES
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	5::real,
	timestamp with time zone '2017-10-2 15:00:00',
	'requested',
	'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'
),
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	5::real,
	timestamp with time zone '2017-10-2 15:01:04',
	'accepted',
	NULL
);

---
-- The control 0 was requested to change its value. The change would probably
-- occur well as we've already received acknowladge - thus 'accepted' state.
-- There is however no confirmed value yet.
---
SELECT results_eq(
	$$ SELECT
		to_timestamp(confirmed_state_at),
		confirmed_state_value,
		confirmed_state_stability,
		confirmed_state_originator_user_id,
		to_timestamp(current_state_at),
		current_state_value,
		current_state_stability,
		current_state_originator_user_id
	FROM controls_recent_state(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint
	) $$,
	$$ VALUES (
		NULL::timestamp with time zone,
		NULL::real,
		NULL::smallint,
		NULL::uuid,
		timestamp with time zone '2017-10-2 15:01:04',
		5::real,
		from_control_stability('accepted'),
		NULL::uuid
	) $$,
	'expected no confirmed state and the current state to be "accepted"'
);

INSERT INTO controls_recent (gateway_id, device_id, module_id, value, at, stability, originator_user_id)
VALUES
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	5::real,
	timestamp with time zone '2017-10-2 15:01:46',
	'confirmed',
	NULL
);

---
-- The requested value for control 0 has been confirmed.
---
SELECT results_eq(
	$$ SELECT
		to_timestamp(confirmed_state_at),
		confirmed_state_value,
		confirmed_state_stability,
		confirmed_state_originator_user_id,
		to_timestamp(current_state_at),
		current_state_value,
		current_state_stability,
		current_state_originator_user_id
	FROM controls_recent_state(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint
	) $$,
	$$ VALUES (
		timestamp with time zone '2017-10-2 15:01:46',
		5::real,
		from_control_stability('confirmed'),
		NULL::uuid,
		timestamp with time zone '2017-10-2 15:01:46',
		5::real,
		from_control_stability('confirmed'),
		NULL::uuid
	) $$,
	'expected the confirmed state and the current state to be equal'
);

INSERT INTO controls_recent (gateway_id, device_id, module_id, value, at, stability, originator_user_id)
VALUES
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	15::real,
	timestamp with time zone '2017-10-2 15:05:11',
	'requested',
	'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'
);

---
-- The user has requested for another change of control 0. Thus,
-- we now have a stable/confirmed state and a change in progress.
---
SELECT results_eq(
	$$ SELECT
		to_timestamp(confirmed_state_at),
		confirmed_state_value,
		confirmed_state_stability,
		confirmed_state_originator_user_id,
		to_timestamp(current_state_at),
		current_state_value,
		current_state_stability,
		current_state_originator_user_id
	FROM controls_recent_state(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint
	) $$,
	$$ VALUES (
		timestamp with time zone '2017-10-2 15:01:46',
		5::real,
		from_control_stability('confirmed'),
		NULL::uuid,
		timestamp with time zone '2017-10-2 15:05:11',
		15::real,
		from_control_stability('requested'),
		'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'::uuid
	) $$,
	'expected an existing confirmed state and the current state to be "requested"'
);

INSERT INTO controls_recent (gateway_id, device_id, module_id, value, at, stability, originator_user_id)
VALUES
(
	1240795450208837,
	to_device_id(11678152912333531136::numeric(20, 0)),
	0,
	8::real,
	timestamp with time zone '2017-10-2 15:05:11',
	'overriden',
	NULL
);

---
-- While requesting (and waiting) a new change of control 0, the control 0
-- reports another value. This does not mean, the request is cancelled because
-- both the user and the control has sent the message at the same time.
-- However, the last stable (confirmed) value is now 8, the 'overriden' value.
---
SELECT results_eq(
	$$ SELECT
		to_timestamp(confirmed_state_at),
		confirmed_state_value,
		confirmed_state_stability,
		confirmed_state_originator_user_id,
		to_timestamp(current_state_at),
		current_state_value,
		current_state_stability,
		current_state_originator_user_id
	FROM controls_recent_state(
		1240795450208837,
		11678152912333531136::numeric(20, 0),
		0::smallint
	) $$,
	$$ VALUES (
		timestamp with time zone '2017-10-2 15:05:11',
		8::real,
		from_control_stability('overriden'),
		NULL::uuid,
		timestamp with time zone '2017-10-2 15:05:11',
		15::real,
		from_control_stability('requested'),
		'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'::uuid
	) $$,
	'expected the confirmed state to be "overriden" and the current state to be "requested"'
);

SELECT finish();
ROLLBACK;
