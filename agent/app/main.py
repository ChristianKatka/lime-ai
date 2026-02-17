
from fastapi import FastAPI, HTTPException, Body
from pydantic import BaseModel
from app.utils.vllm_client import VLLMClient
import json
import re

app = FastAPI(title="Lime AI Agent")


system_prompt = """You are LimeRisk, an enterprise transaction risk triage assistant.

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
    model_name="TinyLlama/TinyLlama-1.1B-Chat-v1.0",
    system_prompt=system_prompt,
    temperature=0.0
)

# Health check endpoint
@app.get("/health")
def health():
    return {"status": "ok"}



class ChatRequest(BaseModel):
    message: str

# Main chat endpoint - sends user message to vLLM and returns risk assessment
@app.post("/chat")
def chat(request: ChatRequest):
    try:
        raw_response = vllm_client.chat(request.message)

        # Extract first JSON object from model output
        match = re.search(r"\{.*\}", raw_response, re.DOTALL)
        if not match:
            raise ValueError("No valid JSON found in model output")

        parsed = json.loads(match.group(0))
        return parsed

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))