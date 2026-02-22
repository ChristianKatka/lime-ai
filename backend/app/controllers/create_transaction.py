import uuid
from datetime import datetime
from app.services.sqs.put_to_sqs_queue import put_to_sqs_queue

def create_transaction(transaction: dict):
    
    print("create_transaction and putting it to SQS Queue...")
    response = put_to_sqs_queue(transaction)
    return response




# Payload aka transaction looks like this:
#   {
#     "transaction_id": "TX-1002",
#     "timestamp": "2026-02-17T10:02:11Z",
#     "customer_id": "CUST-11209",
#     "customer_country": "Finland",
#     "amount_eur": 480,
#     "currency": "EUR",
#     "destination_country": "Finland",
#     "destination_bank_type": "Retail",
#     "payment_method": "Card",
#     "description": "Electronics purchase.",
#     "is_new_beneficiary": false,
#     "customer_risk_profile": "Low"
#   }