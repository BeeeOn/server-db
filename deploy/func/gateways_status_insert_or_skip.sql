-- beeeon-server, pg

BEGIN;

DROP FUNCTION beeeon.gateways_status_insert_or_skip(
	bigint,
	bigint,
	varchar(40),
	varchar(45)
);

COMMIT;
