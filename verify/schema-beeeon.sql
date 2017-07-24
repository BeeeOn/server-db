-- beeeon-server, pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('beeeon', 'usage');

SELECT has_function_privilege(
	'beeeon.always_fail(text)',
	'execute'
);

SELECT has_function_privilege(
	'beeeon.assure_function(text, text)',
	'execute'
);

SELECT has_function_privilege(
	'beeeon.assure_type(text, text)',
	'execute'
);

ROLLBACK;

