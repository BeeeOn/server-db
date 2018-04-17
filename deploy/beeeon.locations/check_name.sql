-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.locations
	ADD CONSTRAINT check_name_valid
	CHECK (name ~ '^[[:alnum:] \.:!?()/,\-_#''$€¥£©®]*$');

COMMIT;
