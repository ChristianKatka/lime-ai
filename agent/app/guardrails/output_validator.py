import json

# Validate that LLM output is valid JSON matching our risk assessment schema
def validate_risk_assessment(response: str) -> dict:
    try:
        data = json.loads(response)
    except json.JSONDecodeError:
        raise ValueError("LLM response is not valid JSON")
    
    # Check required fields
    required_fields = [
        "summary", "risk_level", "risk_score", 
        "risk_categories", "red_flags", "missing_information",
        "recommended_actions", "confidence"
    ]
    
    for field in required_fields:
        if field not in data:
            raise ValueError(f"Missing required field: {field}")
    
    # Validate risk_level
    if data["risk_level"] not in ["LOW", "MEDIUM", "HIGH"]:
        raise ValueError(f"Invalid risk_level: {data['risk_level']}")
    
    # Validate risk_score range
    if not isinstance(data["risk_score"], int) or not (0 <= data["risk_score"] <= 100):
        raise ValueError(f"Invalid risk_score: {data['risk_score']} (must be 0-100)")
    
    # Validate confidence
    if data["confidence"] not in ["LOW", "MEDIUM", "HIGH"]:
        raise ValueError(f"Invalid confidence: {data['confidence']}")
    
    # Validate risk_score matches risk_level
    score = data["risk_score"]
    level = data["risk_level"]
    if (level == "LOW" and not (0 <= score <= 33)) or \
       (level == "MEDIUM" and not (34 <= score <= 66)) or \
       (level == "HIGH" and not (67 <= score <= 100)):
        raise ValueError(f"risk_score {score} doesn't match risk_level {level}")
    
    return data
