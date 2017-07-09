-- beeeon-server, pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'gateways_update(bigint, varchar(250), integer, double precision, double precision)'
);

ROLLBACK;
