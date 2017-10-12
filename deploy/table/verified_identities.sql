-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.verified_identities (
	id uuid NOT NULL,
	identity_id uuid NOT NULL,
	user_id uuid NOT NULL,
	provider varchar(250) NOT NULL,
	picture varchar(250),
	access_token varchar(250),
	CONSTRAINT verified_identities_pk PRIMARY KEY (id),
	CONSTRAINT verified_identities_identities_fk FOREIGN KEY (identity_id) REFERENCES beeeon.identities (id),
	CONSTRAINT verified_identities_users_fk FOREIGN KEY (user_id) REFERENCES beeeon.users (id),
	CONSTRAINT unique_verified_identity UNIQUE (identity_id, provider)
);

GRANT SELECT, INSERT, UPDATE, DELETE
	ON TABLE beeeon.verified_identities
	TO beeeon_user;

COMMIT;
