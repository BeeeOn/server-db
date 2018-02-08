INSERT INTO beeeon.gateways (
	id,
	name,
	altitude,
	latitude,
	longitude,
	timezone
)
VALUES (
	$1::bigint,
	$2::varchar,
	$3::integer,
	$4::double precision,
	$5::double precision,
	$6::varchar(64)
)
