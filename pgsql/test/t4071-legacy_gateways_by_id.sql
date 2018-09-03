SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

\set query $$ `cat queries/legacy_gateways/fetch_by_id.sql`; $$

BEGIN;

CREATE OR REPLACE FUNCTION legacy_gateways_by_id(uuid, bigint)
RETURNS TABLE (
	id bigint,
	name varchar(250),
	altitude integer,
	latitude double precision,
	longitude double precision,
	timezone varchar(64),
	last_changed bigint,
	version varchar(40),
	ip varchar(45),
	roles_count bigint,
	devices_count bigint,
	owner_id uuid,
	owner_first_name varchar(250),
	owner_last_name varchar(250),
	access_level smallint
) AS :query LANGUAGE SQL;

SELECT plan(1);

SELECT is_empty(
	$$ SELECT * FROM legacy_gateways_by_id('56ffcd4a-49f3-406f-a452-e0c734f4ed8a', 1240795450208837) $$,
	'there is nothing yet in the gateways table'
);

SELECT finish();
ROLLBACK;
