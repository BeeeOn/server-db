-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.devices_insert(
	numeric(20, 0),
	bigint,
	uuid,
	varchar(250),
	smallint,
	integer,
	smallint,
	smallint,
	bigint,
	bigint,
	bigint
);

COMMIT;
