-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_insert(bigint, varchar(250), integer, double precision, double precision, varchar(64))'
);

ROLLBACK;
