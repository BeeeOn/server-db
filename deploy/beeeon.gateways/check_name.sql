-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.gateways
	ADD CONSTRAINT check_name_valid
	CHECK (name ~ '^[[:alnum:] \.:!?()/,\-_#''$€¥£©®+]*$');

COMMIT;
