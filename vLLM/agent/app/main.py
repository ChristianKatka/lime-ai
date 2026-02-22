
from pydantic import BaseModel
from app.utils.vllm_client import VLLMClient
from app.guardrails.output_validator import validate_risk_assessment
from app.guardrails.input_validator import validate_input_message
from app.services.postgresql.db import put_risk_assessment_document_to_db
import json
import re
import uuid
from datetime import datetime, timezone
from app.constants.index import SQS_QUEUE_URL
from app.instances.index import get_sqs_client

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
    # If your input validator expects a string, just pass JSON string
    msg = json.dumps(transaction)
    validate_input_message(msg)

    raw_response = vllm_client.chat(msg)
    validated = validate_risk_assessment(raw_response)

    validated["id"] = str(uuid.uuid4())
    validated["time_stamp"] = datetime.now(timezone.utc).isoformat()

    put_risk_assessment_document_to_db(validated)
    return validated

def main():
    while True:
        resp = sqs_client.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=20,     # long poll | these values matches sqs config
            VisibilityTimeout=120,  # give yourself time to process | these values matches sqs config
        )

        msgs = resp.get("Messages", [])
        if not msgs:
            continue

        m = msgs[0]
        receipt = m["ReceiptHandle"]

        try:
            transaction = json.loads(m["Body"])
            process_transaction(transaction)
            sqs_client.delete_message(QueueUrl=SQS_QUEUE_URL, ReceiptHandle=receipt)
        except Exception as e:
            # IMPORTANT: don't delete message -> it will retry after visibility timeout
            print(f"ERROR processing message: {e}")


# Only run main() if this file is executed directly.
# So this prevents infinite SQS loop from starting if the file (main.py) is imported as a module.
# just a safety pattern
if __name__ == "__main__":
    main()