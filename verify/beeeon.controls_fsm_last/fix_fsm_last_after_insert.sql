-- beeeon-server, pg

BEGIN;

SELECT 1 / COUNT(*)
FROM
	pg_catalog.pg_proc AS p
JOIN
	pg_catalog.pg_namespace AS n
ON
	p.pronamespace = n.oid
WHERE
	p.proname = 'controls_fsm_last_after_insert'
	AND
	n.nspname = 'beeeon'
	AND
	pg_get_functiondef(p.oid) NOT LIKE $$%\_accepted\_at%$$
	AND
	pg_get_functiondef(p.oid) NOT LIKE $$%\_value%$$
	AND
	pg_get_functiondef(p.oid) NOT LIKE $$%\_originator\_user\_id%$$;

ROLLBACK;
