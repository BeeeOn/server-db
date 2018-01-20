SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query `cat _api/locations.create.sql`

BEGIN;

PREPARE locations_insert(varchar, varchar, bigint)
AS :query;

SELECT plan(4);

SELECT throws_ok(
	$$ EXECUTE locations_insert('36dd0e4c-e049-44e1-be03-0c7bbca705f2', 'Living room', 1509106553732838) $$,
	23503,
	NULL,
	'cannot insert location associated with a non-existing gateway'
);

INSERT INTO gateways (id, name, altitude, latitude, longitude)
VALUES (1509106553732838, 'MyHome', 0, 0.0, 0.0);

SELECT lives_ok(
	$$ EXECUTE locations_insert('36dd0e4c-e049-44e1-be03-0c7bbca705f2', 'Living room', 1509106553732838) $$,
	'location should be inserted associated with the existing gateway 1509106553732838'
);

SELECT ok(EXISTS(
	SELECT 1 FROM locations
	WHERE
		id = '36dd0e4c-e049-44e1-be03-0c7bbca705f2'
		AND
		name = 'Living room'
		AND
		gateway_id = 1509106553732838
	),
	'location of ID 36dd0e4c-e049-44e1-be03-0c7bbca705f2 should have been inserted'
);

SELECT throws_ok(
	$$ EXECUTE locations_insert('36dd0e4c-e049-44e1-be03-0c7bbca705f2', 'Living room', 1509106553732838) $$,
	23505,
	NULL,
	'primary key violation when creating the same location twice'
);

SELECT finish();
ROLLBACK;
