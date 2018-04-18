---
-- Execute the given dynamic SQL query and report
-- its query plan via RAISE NOTICE.
---
CREATE OR REPLACE FUNCTION explain_analyze(q text)
RETURNS VOID AS
$$
DECLARE
	line text;
	eq text;
BEGIN
	RAISE NOTICE 'QUERY PLAN';
	RAISE NOTICE '%', q;

	eq := format('EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS) %s', q);

	FOR line IN EXECUTE eq LOOP
		RAISE NOTICE '%', line;
	END LOOP;
END
$$ LANGUAGE plpgsql;
