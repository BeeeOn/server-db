-- beeeon-server, pg

BEGIN;

SET client_min_messages = 'warning';

CREATE TABLE beeeon.gateways_messages (
	id uuid NOT NULL,
	gateway_id bigint NOT NULL,
	at timestamp NOT NULL DEFAULT (NOW() AT TIME ZONE 'UTC'),
	severity smallint NOT NULL DEFAULT 0,
	key varchar(64) NOT NULL,
	context jsonb,

	CONSTRAINT gateways_messages_pk PRIMARY KEY (id),
	CONSTRAINT gateways_messages_gateways_fk
		FOREIGN KEY (gateway_id)
		REFERENCES beeeon.gateways (id),
	CONSTRAINT unique_and_orderable UNIQUE (gateway_id, at, severity, key),
	CONSTRAINT check_severity CHECK (severity >= 0 AND severity < 3)
);

COMMIT;
