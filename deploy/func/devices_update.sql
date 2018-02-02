-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_update(
	numeric,
	bigint,
	uuid,
	varchar,
	smallint,
	integer,
	smallint,
	smallint,
	bigint
);

COMMIT;
