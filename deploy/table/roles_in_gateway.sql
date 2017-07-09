-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.roles_in_gateway (
	id uuid NOT NULL,
	gateway_id bigint NOT NULL,
	identity_id uuid NOT NULL,
	level smallint NOT NULL,
	created timestamp with time zone NOT NULL,
	CONSTRAINT roles_in_gateway_pk PRIMARY KEY (id),
	CONSTRAINT roles_in_gateway_gateways_fk FOREIGN KEY (gateway_id) REFERENCES beeeon.gateways (id),
	CONSTRAINT roles_in_gateway_identities_fk FOREIGN KEY (identity_id) REFERENCES beeeon.identities (id),
	CONSTRAINT check_valid_level CHECK (level >= 0 AND level <= 100),
	CONSTRAINT gateway_with_identity UNIQUE (gateway_id, identity_id),
	CONSTRAINT gateway_with_created UNIQUE (gateway_id, created)
);


COMMIT;
