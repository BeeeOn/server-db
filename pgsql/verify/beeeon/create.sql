-- beeeon-server, pg

BEGIN;

SELECT has_schema_privilege('beeeon', 'usage');

SELECT 1 / COUNT(*) FROM pg_catalog.pg_roles WHERE rolname = 'beeeon_user';

SELECT has_schema_privilege('beeeon_user', 'beeeon', 'usage');

ROLLBACK;
