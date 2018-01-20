-- beeeon-server pg

BEGIN;

SELECT beeeon.assure_function(
	'beeeon',
	'fcm_tokens_replace(varchar(250), varchar(250))'
);

ROLLBACK;
