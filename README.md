BeeeOn Database
===============

The BeeeOn Database schema and queries managed by the Sqitch [1].
The Sqitch is unnecessary, however, very very handy when deploying
the database schema.

Automatic unit testing is performed by pgTAP [2]. The pgTAP is a
PostgreSQL extension introducing commands to produce TAP output.

[1] https://github.com/theory/sqitch
[2] http://pgtap.org/


Deploy database
---------------

To deploy the schema and prepared queries into a prepared database
named 'beeeon', just use the following command:

	$ sqitch deploy --verify pg:db:beeeon

It is assumed that the PostgreSQL instance is running on the current
machine and that the current user has proper access into the database.


Revert database
---------------

The whole database schema or just particular changes can be reverted
by using the following command"

	$ sqitch revert pg:db:beeeon

See help for specification of revision to revert to.


Database development
--------------------

For developing purposes, the database 'beeeon_test' is assumed to exists.
If it does not, create it:

	user $ su postgres -c "psql"
	> CREATE ROLE user;
	> \q
	user $ createdb beeeon_test

Then, use sqitch to deploy, verify and revert the database schema:

	$ sqitch deploy --verify
	$ sqitch revert


Unit tests
----------

As much as possible of the database contents (tables, constraints, functions,
queries, ...) is unit tested via pgTAP. To execute unit tests, simply run

	$ pg_prove test/t*.sql
