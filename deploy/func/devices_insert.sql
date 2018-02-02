-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_insert(
	numeric,
	bigint,
	uuid,
	varchar,
	smallint,
	integer,
	smallint,
	smallint,
	bigint,
	bigint,
	bigint
);

COMMIT;
