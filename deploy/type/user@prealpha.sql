-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.user AS (
	id uuid,
	first_name varchar(250),
	last_name varchar(250),
	locale varchar(32)
);

COMMIT;
