SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(2);

SELECT has_function('controls_recent_state');

SELECT ok(
	NOT EXISTS(
		SELECT * FROM controls_recent_state(1240795450208837, 11678152912333531136::numeric(20, 0), 0::smallint)
	),
	'no reason to fail'
);

INSERT INTO users (id, first_name, last_name, locale)
VALUES ('2bcf60a9-cd37-4f27-a7ab-3e6b740770ed', 'Joe', 'Doe', 'en');

INSERT INTO controls_fsm_history (id, at, value, stability, originator_user_id)
VALUES
(
	'56a18328-e326-45ff-8544-c9503babb34a',
	to_timestamp(1507036096) at time zone 'UTC',
	5::real,
	'requested',
	'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'
),
(
	'5b0d4c2f-5995-4120-8adf-d4d829091220',
	to_timestamp(1507036253) at time zone 'UTC',
	5::real,
	'accepted',
	NULL
),
(
	'3c7a7bdc-300a-4d5a-bc4a-f8d90afe70ff',
	to_timestamp(1507036407) at time zone 'UTC',
	5::real,
	'confirmed',
	NULL
),
(
	'f3f1bc0b-421d-4935-9226-1abe45c22f42',
	to_timestamp(1507036431) at time zone 'UTC',
	15::real,
	'requested',
	'2bcf60a9-cd37-4f27-a7ab-3e6b740770ed'
),
(
	'fd179e29-51ea-4bec-8849-49e5f939ff70',
	to_timestamp(1507036457) at time zone 'UTC',
	8::real,
	'overriden',
	NULL
);

INSERT INTO controls_recent (id, gateway_id, device_id, module_id, confirmed_state_id, current_state_id)
VALUES (
	'faa6004d-8b06-44b8-9d25-9f7bcad53773'
	'3c7a7bdc-300a-4d5a-bc4a-f8d90afe70ff',
	'f3f1bc0b-421d-4935-9226-1abe45c22f42'
);

SELECT finish();
ROLLBACK;
