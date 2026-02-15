def build_messages(system_prompt: str, user_message: str) -> list[dict]:
    return [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_message}
    ]
