-- beeeon-server, pg

BEGIN;

SELECT has_schema_privilege('beeeon', 'usage');

SELECT 1 / COUNT(*) FROM pg_catalog.pg_roles WHERE rolname = 'beeeon_user';

SELECT has_function_privilege(
	'beeeon.always_fail(text)',
	'execute'
);

SELECT has_function_privilege(
	'beeeon.assure_true(bool, text)',
	'execute'
);

SELECT has_function_privilege(
	'beeeon.assure_table_priviledges(text, text, text[])',
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

SELECT beeeon.assure_true(
	has_schema_privilege('beeeon_user', 'beeeon', 'usage'),
	'beeeon_user should have access to schema beeeon'
);

ROLLBACK;

