SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

SET search_path TO beeeon, public;

BEGIN;

SELECT plan(11);

SELECT has_table('users');
SELECT has_pk('users');

SELECT has_column('users', 'id');
SELECT col_type_is('users', 'id', 'uuid');
SELECT col_is_pk('users', 'id');

SELECT has_column('users', 'first_name');
SELECT col_type_is('users', 'first_name', 'character varying(250)');

SELECT has_column('users', 'last_name');
SELECT col_type_is('users', 'last_name', 'character varying(250)');

SELECT throws_ok($$
	INSERT INTO beeeon.users VALUES (
		'18ea6121-f409-4486-a680-0282944a97b2',
		'Franta `cat /etc/passwd`',
		'Ferdinand',
		'en'
	)
	$$,
	23514,
	NULL);

SELECT throws_ok($$
	INSERT INTO beeeon.users VALUES (
		'18ea6121-f409-4486-a680-0282944a97b2',
		'Franta',
		'Ferdinand `rm -rf /`',
		'en'
	)
	$$,
	23514,
	NULL);

SELECT finish();
ROLLBACK;
