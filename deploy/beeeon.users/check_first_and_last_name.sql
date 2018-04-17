-- beeeon-server, pg

BEGIN;

ALTER TABLE beeeon.users
	ADD CONSTRAINT check_first_and_last_name_valid
	CHECK (
		first_name ~ '^[[:alnum:] \.:!?()/,\-_#''$€¥£©®]*$'
		AND
		last_name ~ '^[[:alnum:] \.:!?()/,\-_#''$€¥£©®]*$');

COMMIT;
