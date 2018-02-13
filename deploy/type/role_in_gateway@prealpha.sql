-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.role_in_gateway AS (
	id uuid,
	gateway_id bigint,
	identity_id uuid,
	level smallint,
	created bigint,
	identity_email varchar(250)
);

COMMIT;
