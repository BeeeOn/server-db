#! /bin/sh

die()
{
	echo "$@" >&2
	exit -1
}

query_to_path()
{
	echo perf/`sed 's$\.$/$' <<< "$1"`
}

psql_execute_query()
{
	query="$1"
	shift

	path=`query_to_path "${query}"`

	pushd pgsql

	if [ ! -f "${path}.sql" ]; then
		die "no such ${path}.sql"
	fi

	echo "# ${path}.sql" >&2
	psql -X "$@" -f "${path}.sql"

	popd
}

# Process PostgreSQL query plan from input. It can also process
# plans reported via RAISE NOTICE while dropping some really
# unnecessary lines (when raising from functions).
#
# Each plan mast start with line having text "QUERY PLAN".
# The plan end is detected by testing for either "Execution time:"
# or "Total runtime:".
#
# The extracted plan is printed into a file named after the query
# as <query>.plan. The execution time of each query is reported to
# stdout. Other output is redirected to stderr.
query_plan()
{
	query="$1"
	rm -f "${query}.plan"

	awk -v file="${query}.plan" '
		BEGIN {plan=0}
		/QUERY PLAN/ {plan=2; next}
		/^CONTEXT/ {next}
		/at PERFORM$/ {next}
		plan==0 {print $0 >"/dev/stderr"; next}
		/^[ \t]*$/ {next}
		/^-+/ {next}
		/NOTICE:/ {sub(/^.*NOTICE:/, "")}
		{print $0 >>file}
		plan == 2 {print; plan=1}
		/Execution time:/ {print; plan=0}
		/Total runtime:/ {print; plan=0}
	'
}

psql_execute_query "$@" 2>&1 | query_plan "$1"
