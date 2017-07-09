-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.identities (
	id uuid NOT NULL,
	email varchar(250) NOT NULL,
	CONSTRAINT identities_pk PRIMARY KEY (id),
	CONSTRAINT unique_identity UNIQUE (email),
	CONSTRAINT check_email_valid CHECK (email ~ '^[^@]+@[^@]+$')
);

COMMIT;
