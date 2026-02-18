# Lime AI

vLLM-powered AI agent with FastAPI.

Services:
- vLLM: http://localhost:8000
- Agent API: http://localhost:3000

## Test

```bash
docker compose up -d vllm
curl http://localhost:8000/v1/models
```

Start Agent
```bash

# Start everything
  docker compose up -d

# rebuild agent after code changes
  docker compose up -d --build agent



# CHAT lime ai call
curl -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Analyze this transaction JSON and return the required risk JSON only:\n{\"transaction_id\":\"TX-1001\",\"timestamp\":\"2026-02-17T09:14:22Z\",\"customer_id\":\"CUST-78421\",\"customer_country\":\"Germany\",\"amount_eur\":950000,\"currency\":\"EUR\",\"destination_country\":\"Cayman Islands\",\"destination_bank_type\":\"Offshore\",\"payment_method\":\"Wire Transfer\",\"description\":\"Investment transfer to holding structure.\",\"is_new_beneficiary\":true,\"customer_risk_profile\":\"Medium\"}"}'




docker compose down
docker compose logs

```
test

This is transaction review AI or Risk Report Generator
input:
{
  "type": "transaction_review",
  "content": "Client transferred €950,000 to offshore account in Cayman Islands..."
}

agent output:
{
  "risk_level": "HIGH",
  "risk_score": 87,
  "flags": [
    "Large international transfer",
    "High-risk jurisdiction"
  ],
  "recommended_action": "Manual compliance review required"
}