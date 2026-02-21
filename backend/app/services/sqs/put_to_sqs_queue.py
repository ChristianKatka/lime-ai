import json
import os
from app.instances.index import get_sqs_client

def put_to_sqs_queue(message_body: dict):
    sqs_client = get_sqs_client()
    
    response = sqs_client.send_message(
        QueueUrl=os.environ.get("SQS_QUEUE_URL"),
        MessageBody=json.dumps(message_body)
    )

    return {
        "status": "queued",
        "message_id": response["MessageId"]
    }