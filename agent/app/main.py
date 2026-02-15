from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.vllm_client import VLLMClient
import os

app = FastAPI(title="Lime AI Agent")

vllm_client = VLLMClient(
    base_url=os.getenv("VLLM_BASE_URL", "http://vllm:8000/v1"),
    model_name=os.getenv("MODEL_NAME", "TinyLlama/TinyLlama-1.1B-Chat-v1.0"),
    system_prompt=os.getenv("SYSTEM_PROMPT", "You are a helpful AI assistant.")
)

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    response: str

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/chat", response_model=ChatResponse)
def chat(request: ChatRequest):
    try:
        response = vllm_client.chat(request.message)
        return ChatResponse(response=response)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
