from fastapi import APIRouter
from app.controllers.get_health import get_health
from app.controllers.create_transaction import create_transaction
from app.controllers.get_risk_assessments import get_risk_assessments

router = APIRouter()

@router.get("/health")
def health():
    return get_health()

@router.post("/transactions")
def transactions(payload: dict):
    return create_transaction(payload)

@router.get("/risk")
def risk():
    return get_risk_assessments()
