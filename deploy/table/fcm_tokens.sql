-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.fcm_tokens (
	token varchar(250) NOT NULL,
	user_id uuid NOT NULL,
	CONSTRAINT fcm_tokens_pk PRIMARY KEY (token),
	CONSTRAINT fcm_tokens_fk FOREIGN KEY (user_id) REFERENCES beeeon.users (id)
);

COMMIT;
