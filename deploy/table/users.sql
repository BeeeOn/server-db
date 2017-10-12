-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.users (
	id uuid NOT NULL,
	first_name varchar(250) NOT NULL,
	last_name varchar(250) NOT NULL,
	locale varchar(32) NOT NULL,
	CONSTRAINT users_pk PRIMARY KEY (id)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.users
	TO beeeon_user;

COMMIT;
