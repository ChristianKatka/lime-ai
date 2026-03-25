# Lime AI

vLLM-powered AI agent with FastAPI.

Services:

- vLLM: http://localhost:8000
- Agent API: http://localhost:3000

```bash

# check vLLM is up and show logs
  docker compose logs -f --tail=50 vllm # vLLM logs
  docker compose logs -f agent # My agent code logs

# Start everything
  docker compose up -d

# rebuild agent after code changes
  docker compose up -d --build agent
  docker image prune -f # delete old versions of the agent build. important to run once in a while

  docker system prune -a -f # Clean up Docker's cache:


# SHOW Agents logs:
docker compose logs agent

docker compose down
docker compose logs

```

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
CUDA # The operating system for the GPU. Allocates GPU memory, Launches GPU kernels
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
• Tokenizes input
• Sends tensors to PyTorch
• CUDA runs operations
• GPU calculates next tokens
• Returns response

5️⃣ FastAPI:
• Validates JSON
• Applies guardrails
• Returns clean structured JSON

6️⃣ You see output
