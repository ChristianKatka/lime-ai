import requests

class VLLMClient:
    # Initialize client with vLLM server connection details
    def __init__(self, model_name: str, system_prompt: str, temperature: float):
        self.base_url = "http://vllm:8000/v1"
        self.model_name = model_name
        self.system_prompt = system_prompt
        self.temperature = temperature
        self.timeout = 60

    # Send a chat message to vLLM and return the model's response
    def chat(self, user_message: str) -> str:
        # Endpoint: /chat/completions (OpenAI API standard)
        url = f"{self.base_url}/chat/completions"
        messages = [
                    {"role": "system", "content": self.system_prompt},
                    {"role": "user", "content": user_message},
                    ]    
    
        payload = {
            "model": self.model_name,
            "messages": messages,
            "temperature": self.temperature
        }

        response = requests.post(url, json=payload, timeout=self.timeout)
        
        if response.status_code != 200:
            raise Exception(f"vLLM error {response.status_code}: {response.text}")
        
        result = response.json()
        return result["choices"][0]["message"]["content"]
