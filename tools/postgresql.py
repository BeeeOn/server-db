#! /usr/bin/env python3

import logging
import threading
import signal
import os, sys
import shutil
from testing import postgresql

def db_uri(dsn):
	user = dsn["user"]
	host = dsn["host"]
	port = dsn["port"]
	database = dsn["database"]
	return "db:pg://%s@%s:%u/%s" % (user, host, port, database)

def sqitch_install(dsn, name):
	sqitch = shutil.which('sqitch')
	if sqitch is None:
		logging.warning("no sqitch installation detected")

	if not os.path.isfile("sqitch.plan"):
		logging.warning("no sqitch plan file, skipping")
		return True

	logging.debug("using sqitch executable: %s" % (sqitch))
	return os.system(
		"%s target add %s %s" % (sqitch, name, db_uri(dsn))) == 0

def sqitch_uninstall(name):
	sqitch = shutil.which('sqitch')
	if sqitch is None:
		return False

	if not os.path.isfile("sqitch.plan"):
		return True

	return os.system("%s target remove %s" % (sqitch, name)) == 0

def postgresql_start():
	logging.info("starting PostgreSQL instance")
	instance = postgresql.Postgresql()
	logging.info("started %s" % db_uri(instance.dsn()))
	return instance

if __name__ == "__main__":
	if len(sys.argv) > 1:
		logging.basicConfig(
			level = getattr(logging, sys.argv[1].upper(), logging.INFO)
		)
	else:
		logging.basicConfig(level = logging.INFO)

	event = threading.Event()

	# avoid unexpected termination by SIGTERM, exit gracefully instead.
	signal.signal(signal.SIGTERM, lambda num: event.set())

	if "POSTGRESQL_BASE_DIR" in os.environ:
		base_dir = os.environ["POSTGRESQL_BASE_DIR"]
	else:
		base_dir = None

	postgresql.Postgresql.DEFAULT_SETTINGS["base_dir"] = base_dir

	pg = postgresql_start()
	dsn = pg.dsn()

	# print database connection information for scripts
	print(dsn["host"])
	print(dsn["port"])
	print(dsn["user"])
	print(dsn["database"])

	if sqitch_install(dsn, "auto-testing"):
		logging.info("sqitch target 'auto-testing' was installed")
		logging.debug("you can run sqitch as: sqitch deploy auto-testing")

	logging.debug("waiting for kill %u" % os.getpid())
	# print out pid to let other scripts to kill us if needed
	print(os.getpid(), flush = True)

	try:
		event.wait()
	except:
		pass

	if sqitch_uninstall("auto-testing"):
		logging.info("sqitch_target 'auto-testing' was uninstalled")

	pg.terminate()

	if base_dir is not None:
		shutil.rmtree(base_dir, ignore_errors=True)
