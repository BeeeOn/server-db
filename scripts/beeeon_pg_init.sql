-- beeeon-server, pg

---
-- Database initialization
--
-- The database must be created first and then initialized via the Sqitch scripts.
-- This script creates the database and configures access to it.
--
-- There is a single role:
--
--  * beeeon_admin - management role
--
-- Steps:
--
-- # psql -f beeeon_pg_init.sql
-- # sqitch deploy beeeon
---

\set ON_ERROR_STOP on

\set dbname  beeeon

CREATE DATABASE :dbname;

BEGIN;

CREATE ROLE beeeon_admin WITH LOGIN CREATEROLE;
GRANT ALL ON DATABASE :dbname TO beeeon_admin;

END;
