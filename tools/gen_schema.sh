#! /bin/sh

die()
{
	echo "$@" >&2
	exit 1
}

kill_and_die()
{
	echo "killing ${1}" >&2
	kill ${1}
	shift

	die "$@"
}

# Deploy the current sqitch database setup to the running
# database instance named 'auto-testing' as created by the
# postgresql.py.
auto_deploy()
{
	(sqitch deploy --verify auto-testing \
		|| kill_and_die ${1} "sqitch failed to deploy") \
		| sed 's/^/-- /'
	echo ""
}

print_version()
{
	version=`git describe --always`

	if [ "$?" = "0" ]; then
		echo "---"
		echo "-- Git version: ${version}"
		echo "-- Generated: "`date`
		echo "---"
	fi
}

dump_schema()
{
	pg_dump -n beeeon -s -F plain -O -x \
		-h "${2}" -p "${3}" -U "${4}" "${5}" \
		|| kill_and_die ${1} "pg_dump failed"
}

# Parse output from the postgresql.py script providing information
# about the running database and pid of the running script. The pid
# is useful to make sure that the PostgreSQL instance is terminated
# properly.
gen_schema()
{
	local db_host
	local db_port
	local db_user
	local db_name
	local pid

	read -r db_host || die "no database host"
	read -r db_port || die "no database port"
	read -r db_user || die "no database user"
	read -r db_name || die "no database name"
	read -r pid || die "no pid received"

	print_version
	auto_deploy ${pid}
	dump_schema ${pid} ${db_host} ${db_port} ${db_user} ${db_name}

	kill ${pid}
}

dir=`dirname $0`
pgsql_start=`realpath ${dir}/postgresql.py`

cd pgsql && (${pgsql_start} | gen_schema)
