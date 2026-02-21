from app.services.postgresql.get_all_risk_assessments import get_all_risk_assessments

def get_risk_assessments():
    try:
        print("Fetching risk assessments from database...")
        
      #  psql "host=christian-lime-ai-postgredb.cvkj09hn6us5.eu-north-1.rds.amazonaws.com port=5432 dbname=postgres user=christian sslmode=require"
       # CONNECTION IS HANGING. CHECK EC2 SECURITY GROUP
       # CONTINUE HERE! 
       
        
        # response = get_all_risk_assessments()
        # print(f"Successfully fetched {len(response)} risk assessments")
        # return response
    except Exception as e:
        print(f"Error fetching risk assessments: {str(e)}")
        return {"error": str(e), "status": "failed"}