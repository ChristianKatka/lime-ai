from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from app.utils.vllm_client import VLLMClient
import os

app = FastAPI(title="Lime AI Agent")

vllm_client = VLLMClient(
    base_url="http://vllm:8000/v1",
    model_name="TinyLlama/TinyLlama-1.1B-Chat-v1.0",
    system_prompt="""You are LimeRisk, an enterprise risk analysis assistant for internal use.
                        Your job:
                        - Read the user's case text.
                        - Produce a concise, structured risk assessment.
                        - Be conservative: if information is missing, say what is missing.
                        - Never invent facts. Only use what is in the case text.
                        - If the case is harmless, mark risk as LOW.

                        Output rules:
                        - Output MUST be valid JSON only. No markdown, no extra text.
                        - Follow the schema exactly.
                        - Use short, professional language.

                        Schema:
                        {
                        "summary": string,
                        "risk_level": "LOW" | "MEDIUM" | "HIGH",
                        "risk_score": integer,               
                        "risk_categories": string[],         
                        "red_flags": string[],               
                        "missing_information": string[],       
                        "recommended_actions": string[],      
                        "confidence": "LOW" | "MEDIUM" | "HIGH"
                        }

                        Risk scoring guidance:
                        - LOW: 0-33
                        - MEDIUM: 34-66
                        - HIGH: 67-100"""
)

class ChatRequest(BaseModel):
    message: str
    temperature: float = 0.7

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
