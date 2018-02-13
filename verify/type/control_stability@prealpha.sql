-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_type(
	'beeeon',
	'control_stability'
);

SELECT beeeon.assure_function(
	'beeeon',
	'to_control_stability(smallint)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'to_control_stability(integer)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'from_control_stability(beeeon.control_stability)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'control_stability_is_confirmed(beeeon.control_stability)'
);

ROLLBACK;
