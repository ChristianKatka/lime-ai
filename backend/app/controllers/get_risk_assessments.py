from app.services.postgresql.get_all_risk_assessments import get_all_risk_assessments

def get_risk_assessments():

    print("Fetching risk assessments from database...")
    
    response = get_all_risk_assessments()
    print(f"Successfully fetched {len(response)} risk assessments")
    return response
