import uuid
from datetime import datetime
from app.services.sqs.put_to_sqs_queue import put_to_sqs_queue

def create_transaction(payload: dict):
    request_id = str(uuid.uuid4())

    message_body = {
        "request_id": request_id,
        "timestamp": datetime.utcnow().isoformat(),
        "transaction": payload
    }

    response = put_to_sqs_queue(message_body)
    return response