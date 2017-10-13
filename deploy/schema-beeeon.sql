-- beeeon-server, pg

BEGIN;

CREATE SCHEMA beeeon;

CREATE ROLE beeeon_user WITH LOGIN;
REVOKE ALL
	ON SCHEMA beeeon
	FROM beeeon_user;
REVOKE ALL
	ON ALL TABLES IN SCHEMA beeeon
	FROM beeeon_user;
GRANT USAGE ON SCHEMA beeeon
	TO beeeon_user;

CREATE OR REPLACE FUNCTION beeeon.always_fail(reason text)
RETURNS VOID AS
$$
BEGIN
	RAISE EXCEPTION '%', reason;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.assure_true(result bool, reason text)
RETURNS VOID AS
$$
BEGIN
	IF NOT result THEN
		RAISE EXCEPTION '%', reason;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION beeeon.assure_table_priviledges(
	_user text,
	_table text,
	_priv text[]
) RETURNS VOID AS
$$
DECLARE
	p text;
BEGIN
	FOREACH p IN ARRAY _priv LOOP
		IF has_table_privilege(_user, _table, p) THEN
			CONTINUE;
		END IF;

		RAISE EXCEPTION '%',
			_user || ' should have ' || p || ' privilege to ' || _table;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

-- helper for verify scripts
CREATE OR REPLACE FUNCTION beeeon.assure_function(
	ns text,
	spec text
)
RETURNS BOOLEAN AS
$$
	SELECT has_function_privilege(
		ns || '.' || spec,
		'execute'
	);
$$ LANGUAGE SQL;

-- helper for verify scripts
CREATE OR REPLACE FUNCTION beeeon.assure_type(
	ns   text,
	name text
)
RETURNS bigint AS
$$
	SELECT 1 / COUNT(*)
		FROM pg_catalog.pg_type t
		JOIN pg_catalog.pg_namespace n ON t.typnamespace = n.oid
		WHERE t.typisdefined
			AND n.nspname = ns
			AND t.typname = name;
$$ LANGUAGE SQL;

COMMIT;
