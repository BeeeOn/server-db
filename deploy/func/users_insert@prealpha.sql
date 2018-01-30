-- beeeon-server, pg

BEGIN;

CREATE OR REPLACE FUNCTION beeeon.users_insert(
	_id uuid,
	_first_name varchar(250),
	_last_name varchar(250),
	_locale varchar(32)
)
RETURNS VOID AS
$$
	INSERT INTO beeeon.users (id, first_name, last_name, locale)
	VALUES (_id, _first_name, _last_name, _locale);
$$ LANGUAGE SQL;

COMMIT;
