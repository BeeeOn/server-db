SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query '$$ BEGIN '`cat pgsql/gateways/update.sql`; 'RETURN FOUND; END;' $$

BEGIN;

CREATE OR REPLACE FUNCTION gateways_update(
	bigint, varchar, integer, double precision, double precision, varchar(64))
RETURNS boolean AS :query LANGUAGE plpgsql;

SELECT plan(3);

SELECT ok(
	NOT gateways_update(1522979621558401, 'second gateway', 0, 0.0, 0.0, 'Europe/Paris')
);

INSERT INTO gateways VALUES (1522979621558401, 'first gateway', 0, 0.0, 0.0);

SELECT ok(
	gateways_update(1522979621558401, 'second gateway', 10, -5.0, 5.0, 'Europe/Prague')
);

SELECT results_eq(
	'SELECT id, name, altitude, latitude, longitude, timezone FROM gateways',
	$$ VALUES (
		1522979621558401,
		'second gateway'::varchar(250),
		10,
		-5::double precision,
		5::double precision,
		'Europe/Prague'::varchar(64)
	) $$,
	'update should change name, altitude, latitude, longitude and timezone'
);

SELECT finish();
ROLLBACK;
