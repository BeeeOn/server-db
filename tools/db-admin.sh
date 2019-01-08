#! /bin/sh

# The script db-admin.sh wraps calling of sqitch and simplifies
# management of the BeeeOn database. It automatically determines
# how to connect to the PostgreSQL database and configures sqitch
# for this purpose. Finally it executes the required action via
# sqitch.
#
# The behaviour of this script can be influenced by environment
# variables:
#
# * SERVER_INI - path to the server configuration INI file (must
#                contain the database configuration
# * SQITCH_BIN - path to sqitch binary
# * DB_USER    - name of user to use for login to database
# * DB_NAME    - name of database
# * DB_PORT    - port of database
#
# Normally, all the variables are detected automatically. Under
# certain circumstances, they must be configured manually.

action="$1"
shift

if [ -z "${action}" ] || [ "${action}" = "help" ]; then
	echo "$0 [action]"
	echo "Actions:"
	echo "  help - print help"
	echo "  deploy - deploy changes to database (interactive)"
	echo "  revert - revert changes from database (interactive)"
	echo "  log    - display log of database changes (interactive)"
	echo "  status - report status"
	echo ""
	echo "Environment variables to override:"
	echo "  SERVER_INI - path to server INI with database configuration"
	echo "  SQITCH_BIN - path to sqitch binary"
	echo "  DB_USER    - database user (beeeon_admin)"
	echo "  DB_NAME    - database name"
	echo "  DB_PORT    - database port"
	echo ""
	echo "Examples:"
	echo "  $ sudo $0 status"
	echo "  # $0 status"
	echo "  $ sudo $0 deploy"
	echo "  # $0 deploy"
	echo "  $ SERVER_INI=/usr/local/etc/beeeon/server/server-startup.ini sudo -E $0 status"
	echo "  $ DB_PORT=10000 SQITCH_BIN=/opt/sqitch/bin/sqitch sudo -E $0 status"
	exit 0
fi

detect_sqitch()
{
	export PATH="${PATH}:/usr/local/bin"
	which sqitch
}

test -z "${SERVER_INI}" && SERVER_INI=/etc/beeeon/server/server-startup.ini
test -z "${DB_USER}"    && DB_USER=beeeon_admin
test -z "${SQITCH_BIN}" && SQITCH_BIN=`detect_sqitch`

if [ -z "${SQITCH_BIN}" ]; then
	die "failed to locate sqitch binary"
fi

die()
{
	echo "$@" >&2
	exit 1
}

# Parse INI file and extract the request key given in
# format <section>.<name>.
server_ini_get()
{
	awk < "${SERVER_INI}" -v key="${1}" '
		BEGIN {
			count = split(key, parts, /\./)
			section = parts[1]
			name = parts[2]

			for (i = 3; i <= count; ++i)
				name = name "." parts[i]

			in_section = 0
		}
		/^#/ {next}
		/^\[/ {
			in_section = 0
		}
		$0 == "[" section "]" {
			in_section = 1
		}
		$1 == name && in_section {
			split($0, value, "=")
			sub(/^[ \t]*/, "", value[2])
			sub(/[ \t]*$/, "", value[2])
			print value[2]
		}
	' | expand_value
}

# Replace certain variables expressed as ${<name>}
# in the input.
expand_value()
{
	dir=`dirname "${SERVER_INI}"`
	awk -v DIR="${dir}/" '
		{
			gsub(/\${application.configDir}/, DIR)
			print
		}
	'
}

# Execute the following command as the user given as the
# first argument.
as_user()
{
	user="$1"
	shift
	sudo -u "${user}" "$@"
}

# Run sqitch deploy on the configured database. The database
# condifuration is based on DB_USER. DB_PORT, DB_NAME variables.
sqitch_go()
{
	SQITCH_ARGS="-t db:pg://${DB_USER}@:${DB_PORT}/${DB_NAME}"

	case "$1" in
	deploy)
		as_user "${DB_USER}" ${SQITCH_BIN} deploy ${SQITCH_ARGS}
	;;
	revert)
		as_user "${DB_USER}" ${SQITCH_BIN} revert ${SQITCH_ARGS}
	;;
	log)
		as_user "${DB_USER}" ${SQITCH_BIN} log ${SQITCH_ARGS}
	;;
	status)
		as_user "${DB_USER}" ${SQITCH_BIN} status ${SQITCH_ARGS}
	;;
	*)
		die "unexpected action: $1"
	;;
	esac
}

# Find directory of the sqitch.plan file.
if [ -z "${PLAN_DIR}" ]; then
	QUERY_DIR=`server_ini_get database.queries.fs.rootDir`

	if [ -n "${QUERY_DIR}" ] && [ -f "${QUERY_DIR}/../sqitch.plan" ]; then
		PLAN_DIR="${QUERY_DIR}/../sqitch.plan"
	else
		die "failed to determine location of the sqitch.plan"
	fi
fi

# Auto-detect database port from SERVER_INI.
if [ -z "${DB_PORT}" ]; then
	DB_PORT=`server_ini_get database.port`
fi

# Auto-detect database name from SERVER_INI.
if [ -z "${DB_NAME}" ]; then
	DB_NAME=`server_ini_get database.name`
fi

sqitch_go "${action}"
