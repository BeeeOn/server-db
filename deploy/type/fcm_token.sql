-- beeeon-server, pg

BEGIN;

CREATE TYPE beeeon.fcm_token AS (
	token varchar(250),
	user_id uuid,
	user_first_name varchar(250),
	user_last_name varchar(250),
	user_locale varchar(32)
);

COMMIT;
