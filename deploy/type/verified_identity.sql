-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.verified_identity AS (
	id uuid,
	identity_id uuid,
	user_id uuid,
	provider varchar(250),
	picture varchar(250),
	access_token varchar(250),
	identity_email varchar(250),
	user_first_name varchar(250),
	user_last_name varchar(250)
);

COMMIT;
