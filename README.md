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
# If container already exists:

docker start lime-agent

# If not, run:
docker run -d --name lime-agent --network lime-ai_default -p 3000:3000 \
  lime-agent

# stop and delete
docker stop lime-agent
docker rm lime-agent


# CHAT lime ai call
curl -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Say hello in one short sentence."}'




# Then try this outside of the ec2 instance. 8000 kutsuu suoraan vLLM eikä minun lime-ai
curl http://13.62.34.37:8000/v1/models

# Näytä env variable
docker inspect lime-agent --format '{{range .Config.Env}}{{println .}}{{end}}' | grep SYSTEM_PROMPT

[ec2-user@ip-172-31-35-89 lime-ai]$
```


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