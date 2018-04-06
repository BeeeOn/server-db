UPDATE beeeon.gateways
SET
	name = $2::varchar,
	altitude = $3::integer,
	latitude = $4::double precision,
	longitude = $5::double precision,
	timezone = $6::varchar(64)
WHERE
	id = $1::bigint
