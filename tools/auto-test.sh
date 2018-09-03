#! /bin/sh

test -z "${RESULT_FILE}" && RESULT_FILE=result.tgz

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
	sqitch deploy --verify auto-testing \
		|| kill_and_die ${1} "sqitch failed to deploy"

}

# Execute pg_prove to test the database setup.
auto_prove()
{
	pushd pgsql
	pg_prove -a "${RESULT_FILE}" -h "${2}" -p "${3}" -U "${4}" -d "${5}" \
		test/t*.sql || kill_and_die ${1} "pg_prove failed"
	popd
}

# Revert the current sqitch database setup to make sure that
# the revert commands works as expected.
auto_revert()
{
	sqitch revert -y auto-testing \
		|| kill_and_die ${1} "sqitch failed to revert"
}

# Parse output from the postgresql.py script providing information
# about the running database and pid of the running script. The pid
# is useful to make sure that the PostgreSQL instance is terminated
# properly.
auto_test_run()
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

	auto_deploy ${pid}
	auto_prove ${pid} ${db_host} ${db_port} ${db_user} ${db_name}
	auto_revert ${pid}

	kill ${pid}
}

dir=`dirname $0`
${dir}/postgresql.py | auto_test_run
