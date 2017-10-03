SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(34);

SELECT has_type('control_stability');
SELECT has_function('to_control_stability');
SELECT has_function('from_control_stability');
SELECT has_function('control_stability_is_confirmed');

SELECT is(to_control_stability(0), 'unknown');
SELECT is(to_control_stability(1), 'requested');
SELECT is(to_control_stability(2), 'accepted');
SELECT is(to_control_stability(3), 'unconfirmed');
SELECT is(to_control_stability(4), 'confirmed');
SELECT is(to_control_stability(5), 'overriden');
SELECT is(to_control_stability(6), 'stuck');
SELECT is(to_control_stability(7), 'failed_rollback');
SELECT is(to_control_stability(8), 'failed_unknown');

SELECT throws_ok(
	$$ SELECT to_control_stability(9) $$,
	'P0001',
	NULL,
	'9 is not a value representing control_stability'
);

SELECT throws_ok(
	$$ SELECT to_control_stability(NULL::smallint) $$,
	'P0001',
	NULL,
	'cannot convert NULL to control_stability'
);

SELECT is(from_control_stability('unknown'), 0::smallint);
SELECT is(from_control_stability('requested'), 1::smallint);
SELECT is(from_control_stability('accepted'), 2::smallint);
SELECT is(from_control_stability('unconfirmed'), 3::smallint);
SELECT is(from_control_stability('confirmed'), 4::smallint);
SELECT is(from_control_stability('overriden'), 5::smallint);
SELECT is(from_control_stability('stuck'), 6::smallint);
SELECT is(from_control_stability('failed_rollback'), 7::smallint);
SELECT is(from_control_stability('failed_unknown'), 8::smallint);

SELECT is(from_control_stability(NULL), NULL);

SELECT ok(NOT control_stability_is_confirmed('unknown'));
SELECT ok(NOT control_stability_is_confirmed('requested'));
SELECT ok(NOT control_stability_is_confirmed('accepted'));
SELECT ok(NOT control_stability_is_confirmed('unconfirmed'));
SELECT ok(control_stability_is_confirmed('confirmed'));
SELECT ok(control_stability_is_confirmed('overriden'));
SELECT ok(control_stability_is_confirmed('stuck'));
SELECT ok(control_stability_is_confirmed('failed_rollback'));
SELECT ok(control_stability_is_confirmed('failed_unknown'));

SELECT finish();
ROLLBACK;
