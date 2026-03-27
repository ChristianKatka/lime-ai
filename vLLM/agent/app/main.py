
from pydantic import BaseModel
from app.utils.vllm_client import VLLMClient
from app.guardrails.output_validator import validate_risk_assessment
from app.guardrails.input_validator import validate_input_message
from app.services.postgresql.db import put_risk_assessment_document_to_db
from app.constants.index import SQS_QUEUE_URL
from app.instances.index import get_sqs_client
import json
import re
import uuid
from datetime import datetime, timezone


system_prompt = """You are Lime AI, an enterprise transaction risk triage assistant.

You MUST follow these rules:
- Use ONLY the information in the user's input. Do NOT invent or guess.
- If a required field is missing, put it in "missing_information".
- Output MUST be a SINGLE valid JSON object and nothing else.
- No markdown. No commentary. No labels like 'Response:'.
- All fields must be present. Use empty arrays [] when needed.

Risk level rules:
- HIGH if there is an offshore destination, sanctions-sensitive destination, unusually large amount, or new beneficiary with large transfer.
- MEDIUM for moderate risk profile with some uncertainty.
- LOW only for clearly normal, low-risk transactions.

Return JSON with EXACT schema:
{
  "summary": "string",
  "risk_level": "LOW" | "MEDIUM" | "HIGH",
  "risk_score": 0-100,
  "risk_categories": ["AML" | "Fraud" | "Sanctions" | "Operational" | "DataPrivacy"],
  "red_flags": ["string"],
  "missing_information": ["string"],
  "recommended_actions": ["string"],
  "confidence": "LOW" | "MEDIUM" | "HIGH"
}

If you cannot comply with JSON-only output, output this exact JSON:
{"summary":"", "risk_level":"LOW", "risk_score":0, "risk_categories":[], "red_flags":[], "missing_information":["Model failed to produce valid JSON output"], "recommended_actions":["Retry with lower temperature"], "confidence":"LOW"}"""

vllm_client = VLLMClient(
    model_name="meta-llama/Llama-3.1-8B-Instruct",
    system_prompt=system_prompt,
    temperature=0.0,
)

sqs_client = get_sqs_client()

def process_transaction(transaction: dict) -> dict:
    print(f"[PROCESS] Starting transaction processing: {transaction.get('id', 'unknown')}")
    
    # If your input validator expects a string, just pass JSON string
    msg = json.dumps(transaction)
    print("[PROCESS] Input validation starting...")
    validate_input_message(msg)
    print("[PROCESS] ✓ Input validation passed")

    print("[PROCESS] Calling vLLM model...")
    raw_response = vllm_client.chat(msg)
    print(f"[PROCESS] ✓ vLLM response received: {raw_response[:100]}...")
    
    print("[PROCESS] Output validation starting...")
    validated = validate_risk_assessment(raw_response)
    print(f"[PROCESS] ✓ Output validation passed")
    print(f"[PROCESS] ✓ Risk Level Of Risk assesment: {validated.get('risk_level')}")

    validated["id"] = str(uuid.uuid4())
    validated["time_stamp"] = datetime.now(timezone.utc).isoformat()

    print("[PROCESS] Saving to database...")
    print(json.dumps(validated, indent=4))
    put_risk_assessment_document_to_db(validated)
    print("[PROCESS] ✓ Successfully saved to database")
    
    return validated

def main():
    print("[MAIN] Starting SQS polling loop...")
    while True:
        print("[MAIN] Polling SQS for messages...")
        resp = sqs_client.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=20,     # long poll | these values matches sqs config
            VisibilityTimeout=120,  # give yourself time to process | these values matches sqs config
        )

        msgs = resp.get("Messages", [])
        if not msgs:
            print("[MAIN] No messages received, continuing poll...")
            continue

        m = msgs[0]
        receipt = m["ReceiptHandle"]
        print(f"[MAIN] ✓ Message received: {m.get('MessageId', 'unknown')}")

        try:
            print("[MAIN] Parsing message body...")
            transaction = json.loads(m["Body"])
            print(f"[MAIN] ✓ Message parsed successfully")
            
            process_transaction(transaction)
            print("[MAIN] ✓ Transaction processed successfully")
            
            print("[MAIN] Deleting message from queue...")
            sqs_client.delete_message(QueueUrl=SQS_QUEUE_URL, ReceiptHandle=receipt)
            print("[MAIN] ✓ Message deleted from queue")
            
        except Exception as e:
            # IMPORTANT: don't delete message -> it will retry after visibility timeout
            print(f"[MAIN] ✗ ERROR processing message: {e}")
            print(f"[MAIN] Message will remain in queue for retry")


# Only run main() if this file is executed directly.
# So this prevents infinite SQS loop from starting if the file (main.py) is imported as a module.
# just a safety pattern
if __name__ == "__main__":
    main()