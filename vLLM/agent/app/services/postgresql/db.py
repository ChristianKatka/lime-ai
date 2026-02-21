import os
from psycopg import connect
import json

def get_conn():
    return connect(
        host="christian-lime-ai-postgredb.cvkj09hn6us5.eu-north-1.rds.amazonaws.com",
        port=5432,
        dbname="postgres",
        user="lime_agent",
        password=os.environ["DB_PASSWORD"],
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