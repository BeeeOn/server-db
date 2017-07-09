SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(5);

SELECT has_function('gateways_status_most_recent');

SELECT is(
	gateways_status_most_recent(1151460236578635),
	NULL,
	'there is no gateway of id 1151460236578635'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (1151460236578635, 'testing', 1, 2, 3);

SELECT is(
	gateways_status_most_recent(1151460236578635),
	NULL,
	'there is no status for the gateway yet'
);

INSERT INTO gateways_status (gateway_id, at, version, ip)
VALUES (
	1151460236578635,
	timestamp with time zone '2017-7-7 22:17:58',
	'master',
	'192.168.0.2'
);

SELECT is(
	gateways_status_most_recent(1151460236578635),
	timestamp with time zone '2017-7-7 22:17:58',
	'expected the only status that is available'
);

INSERT INTO gateways_status (gateway_id, at, version, ip)
VALUES (
	1151460236578635,
	timestamp with time zone '2017-7-7 22:34:38',
	'testing',
	'192.168.0.2'
);

SELECT is(
	gateways_status_most_recent(1151460236578635),
	timestamp with time zone '2017-7-7 22:34:38',
	'selected wrong newest status'
);

SELECT finish();
ROLLBACK;
