import requests
from app.utils.prompts.prompts import build_messages

class VLLMClient:
    def __init__(self, base_url: str, model_name: str, system_prompt: str):
        self.base_url = base_url.rstrip("/")
        self.model_name = model_name
        self.system_prompt = system_prompt
        self.timeout = 60

    def chat(self, user_message: str) -> str:
        url = f"{self.base_url}/chat/completions"
        messages = build_messages(self.system_prompt, user_message)
        
        payload = {
            "model": self.model_name,
            "messages": messages
        }

        response = requests.post(url, json=payload, timeout=self.timeout)
        
        if response.status_code != 200:
            raise Exception(f"vLLM error {response.status_code}: {response.text}")
        
        result = response.json()
        return result["choices"][0]["message"]["content"]
