import os

import psycopg2


def get_db(withdb=True):
    return psycopg2.connect(
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("ATHENA_DB_SERVICE_HOST"),
        port=os.getenv("ATHENA_DB_SERVICE_PORT"),
        database=os.getenv("POSTGRES_DB"),
    )
