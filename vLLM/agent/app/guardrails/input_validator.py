import json
import re

# Validate input message for security and data quality
def validate_input_message(message: str) -> dict:
    # Check message size (prevent huge payloads)
    max_size = 50000  # 50KB
    if len(message) > max_size:
        raise ValueError(f"Message too large: {len(message)} bytes (max {max_size})")
    
    # Check for empty message
    if not message or not message.strip():
        raise ValueError("Message cannot be empty")
    
    # Try to parse as JSON if it looks like JSON
    message_stripped = message.strip()
    if message_stripped.startswith('{'):
        try:
            data = json.loads(message)
        except json.JSONDecodeError:
            raise ValueError("Message appears to be JSON but is malformed")
    else:
        # Plain text message
        data = {"text": message}
    
    # Check for prompt injection patterns
    suspicious_patterns = [
        r"ignore\s+(previous|above|all)\s+instructions",
        r"system\s*:\s*you\s+are",
        r"<\s*script\s*>",
        r"DROP\s+TABLE",
        r"DELETE\s+FROM",
        r"--\s*sql",
    ]
    
    message_lower = message.lower()
    for pattern in suspicious_patterns:
        if re.search(pattern, message_lower, re.IGNORECASE):
            raise ValueError(f"Suspicious pattern detected: potential injection attempt")
    
    return data
