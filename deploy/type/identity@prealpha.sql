-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.identity AS (
	id uuid,
	email varchar(250)
);

COMMIT;
