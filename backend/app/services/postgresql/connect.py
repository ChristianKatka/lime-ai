from psycopg import connect
import os

def get_conn():
    return connect(
        host=os.environ["POSTGRES_DB_URL"],
        port=5432,
        dbname="postgres",
        user=os.environ["DB_USERNAME"],
        password=os.environ["DB_PASSWORD"],
        sslmode="require",
    )