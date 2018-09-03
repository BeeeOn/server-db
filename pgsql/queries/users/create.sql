INSERT INTO beeeon.users (
	id,
	first_name,
	last_name,
	locale
)
VALUES (
	$1::uuid,
	$2::varchar,
	$3::varchar,
	$4::varchar
)
