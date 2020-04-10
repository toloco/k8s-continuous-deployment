import os

from rethinkdb import RethinkDB


def get_db(withdb=True):
    return RethinkDB().connect(
        host=os.getenv("RETHINKDB_HOST"),
        port=os.getenv("RETHINKDB_PORT"),
        db=os.getenv("RETHINKDB_DB"),
    )
