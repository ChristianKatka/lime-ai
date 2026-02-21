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

# check vLLM is up and show logs
  docker compose logs -f --tail=50 vllm

# Start everything
  docker compose up -d

# rebuild agent after code changes
  docker compose up -d --build agent
  docker image prune -f # delete old versions of the agent build. important to run once in a while

# SHOW Agents logs:
docker compose logs agent

# CHAT lime ai call
curl -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Analyze this transaction JSON and return the required risk JSON only:\n{\"transaction_id\":\"TX-1001\",\"timestamp\":\"2026-02-17T09:14:22Z\",\"customer_id\":\"CUST-78421\",\"customer_country\":\"Germany\",\"amount_eur\":950000,\"currency\":\"EUR\",\"destination_country\":\"Cayman Islands\",\"destination_bank_type\":\"Offshore\",\"payment_method\":\"Wire Transfer\",\"description\":\"Investment transfer to holding structure.\",\"is_new_beneficiary\":true,\"customer_risk_profile\":\"Medium\"}"}' | jq


curl -X POST http://13.62.34.37:3000/chat \
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






Commands

list all containers:
docker ps -a

List images:
docker image ls

List volumes
docker volume ls



Ymmärrys:::

GPU Hardware (NVIDIA L4)
↓
NVIDIA Driver
↓
CUDA # The operating system for the GPU. Allocates GPU memory,	Launches GPU kernels
↓
PyTorch # PyTorch is the deep learning framework. The neural network is defined, Model weights are loaded
↓
vLLM # Loads model, Manage memory, exposes. API. Open AI Standardi: /v1/chat/completions
↓
FastAPI (your agent) # python koodi voi kutsu /v1/chat/completions
↓
Client (curl / browser / UI)





FULL FLOW:

Kun kutsun:
curl http://localhost:3000/chat
1️⃣ FastAPI receives request

AGENTIN SISÄLLÄ:
2️⃣ validate_input_message() runs
3️⃣ vllm_client.chat() sends HTTP request to:
http://vllm:8000/v1/chat/completions
4️⃣ vLLM:
	•	Tokenizes input
	•	Sends tensors to PyTorch
	•	CUDA runs operations
	•	GPU calculates next tokens
	•	Returns response

5️⃣ FastAPI:
	•	Validates JSON
	•	Applies guardrails
	•	Returns clean structured JSON

6️⃣ You see output