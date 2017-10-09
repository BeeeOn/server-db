-- beeeon-server, pg

---
-- Database drop
--
-- This scripts drops the whole beeeon database and the associated roles.
-- Call this script via psql as:
--
--  $ psql -v force=true -f beeeon_pg_drop.sql
--
-- to work. This prevents to drop the database in case of a mistake.
---

\set ON_ERROR_STOP on
\t on
\pset footer off

SELECT 'failed, try "psql -v force=true ..."' WHERE NOT :force;

\set dbname beeeon

BEGIN;

REVOKE ALL ON DATABASE :dbname FROM beeeon_admin;
DROP ROLE beeeon_admin;

END;

DROP DATABASE :dbname;
