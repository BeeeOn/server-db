-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.legacy_gateway AS (
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
);

COMMIT;
