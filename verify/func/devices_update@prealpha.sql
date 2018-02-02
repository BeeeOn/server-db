-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'devices_update(numeric(20, 0), bigint, uuid, varchar(250), smallint, integer, smallint, smallint, bigint)'
);

ROLLBACK;
