from psycopg import connect
from app.constants.index import POSTGRES_DB_URL, POSTGRES_DB_USERNAME, POSTGRES_DB_PASSWORD
import os

def get_conn():
    return connect(
        host=POSTGRES_DB_URL
        port=5432,
        dbname="postgres",
        user=POSTGRES_DB_USERNAME
        password=POSTGRES_DB_PASSWORD,
        sslmode="require",
    )