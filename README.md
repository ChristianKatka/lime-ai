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
  -e VLLM_BASE_URL=http://vllm:8000/v1 \
  -e MODEL_NAME=TinyLlama/TinyLlama-1.1B-Chat-v1.0 \
  -e SYSTEM_PROMPT="You are a helpful AI assistant." \
  lime-agent


# CHAT
curl -X POST http://localhost:3000/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Say hello in one short sentence."}'




# Then try this outside of the ec2 instance
curl http://13.60.65.146:8000/v1/models
```

