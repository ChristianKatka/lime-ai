import json
import os
from app.instances.index import get_sqs_client
from app.constants.index import SQS_QUEUE_URL

def put_to_sqs_queue(transaction: dict):
    sqs_client = get_sqs_client()
    
    response = sqs_client.send_message(
        QueueUrl=SQS_QUEUE_URL,
        MessageBody=json.dumps(transaction) # json.dumps() converts the Python dict → JSON string.
    )

    return {
        "status": "queued",
        "message_id": response["MessageId"]
    }