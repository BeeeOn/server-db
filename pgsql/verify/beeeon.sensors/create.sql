-- beeeon-server, pg

BEGIN;

SELECT
	gateway_id,
	device_id,
	module_id,
	refid
FROM
	beeeon.sensors
WHERE
	FALSE;

SELECT beeeon.assure_table_priviledges(
	'beeeon_user', 'beeeon.sensors',
	ARRAY['select', 'insert', 'update', 'delete']
);

DO LANGUAGE plpgsql
$$
DECLARE
	p text;
	seq text;
BEGIN
	seq := 'beeeon.sensors_refid_seq';

	FOREACH p IN ARRAY ARRAY['select', 'usage'] LOOP
		IF has_sequence_privilege('beeeon_user', seq, p) THEN
			CONTINUE;
		END IF;

		RAISE EXCEPTION
			'beeeon_user should have % priviledge to %',
			p, seq;
	END LOOP;
END;
$$;

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init(bigint, bigint, smallint)'
);

SELECT beeeon.assure_function(
	'beeeon',
	'sensors_init_trigger()'
);

ROLLBACK;
