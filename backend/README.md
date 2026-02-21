# Backend API

## Docker Compose

Start:
```bash
docker compose up -d
```

Rebuild after code changes:
```bash
docker compose up -d --build
```

Stop:
```bash
docker compose down
```

Logs:
```bash
docker compose logs -f
```

## Test

```bash
curl http://localhost:8001/health | jq

curl http://localhost:8001/risk | jq
 
curl -X POST http://localhost:8001/transactions -H "Content-Type: application/json" -d '{"message":"Analyze this transaction JSON and return the required risk JSON only:\n{\"transaction_id\":\"TX-1001\",\"timestamp\":\"2026-02-17T09:14:22Z\",\"customer_id\":\"CUST-78421\",\"customer_country\":\"Germany\",\"amount_eur\":950000,\"currency\":\"EUR\",\"destination_country\":\"Cayman Islands\",\"destination_bank_type\":\"Offshore\",\"payment_method\":\"Wire Transfer\",\"description\":\"Investment transfer to holding structure.\",\"is_new_beneficiary\":true,\"customer_risk_profile\":\"Medium\"}"}' | jq
```
