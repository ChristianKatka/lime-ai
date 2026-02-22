from psycopg import connect
from app.constants.index import POSTGRES_DB_URL, POSTGRES_DB_USERNAME, POSTGRES_DB_PASSWORD
import json

def get_conn():
    return connect(
        host=POSTGRES_DB_URL,
        port=5432,
        dbname="postgres",
        user=POSTGRES_DB_USERNAME,
        password=POSTGRES_DB_PASSWORD,
        sslmode="require",
    )

def put_risk_assessment_document_to_db(doc: dict):
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO risk_assessments (
                    id,
                    time_stamp,
                    summary,
                    risk_level,
                    risk_score,
                    risk_categories,
                    red_flags,
                    missing_information,
                    recommended_actions,
                    confidence
                )
                VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """,
                (
                    doc["id"],
                    doc["time_stamp"],
                    doc["summary"],
                    doc["risk_level"],
                    doc["risk_score"],
                    doc["risk_categories"],
                    doc["red_flags"],
                    doc["missing_information"],
                    doc["recommended_actions"],
                    doc["confidence"],
                ),
            )