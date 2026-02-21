from psycopg.rows import dict_row 
from app.services.postgresql.connect import get_conn

def get_all_risk_assessments():
    print("Opening database connection...")
    try:
        with get_conn() as conn:
            print("Connection established, creating cursor...")
            with conn.cursor(row_factory=dict_row) as cur:
                print("Executing query...")
                cur.execute("SELECT * FROM risk_assessments ORDER BY time_stamp DESC")
                print("Fetching results...")
                results = cur.fetchall()
                print(f"Query completed, got {len(results)} rows")
                return results
    except Exception as e:
        print(f"Database error: {str(e)}")
        raise



# from psycopg.rows import dict_row 
# from app.services.postgresql.connect import get_conn


# # in python dictionary is object
# # and in python list is san array

# # So in python array of objects is called list of dictionaries

# def get_all_risk_assessments():
#     #  The with ensures it closes automatically when done
#     with get_conn() as conn:
#         with conn.cursor(row_factory=dict_row) as cur: # helper that converts database rows into Python dictionaries 
#             cur.execute("SELECT * FROM risk_assessments ORDER BY time_stamp DESC")
            
#             # We also have fetchone() - get just one row
#             # fetchmany(5) - get 5 rows
#             # and this fetchall returns everything that execute command returned
#             return cur.fetchall()