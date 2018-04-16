-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.devices
	ADD CONSTRAINT check_name_valid
	CHECK (name ~ '^[[:alnum:] \.:!?()/,\-_#''$€¥£©®]*$');

COMMIT;
