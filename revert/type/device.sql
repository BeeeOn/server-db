-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.device AS (
	id varchar,
	gateway_id bigint,
	location_id uuid,
	name varchar(250),
	type smallint,
	refresh integer,
	battery smallint,
	signal smallint,
	first_seen bigint,
	last_seen bigint,
	active_since bigint
);

COMMIT;
