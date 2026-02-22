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
 
curl -X POST http://localhost:8001/transactions -H "Content-Type: application/json" -d '{
    "transaction_id": "TX-1002",
    "timestamp": "2026-02-17T10:02:11Z",
    "customer_id": "CUST-11209",
    "customer_country": "Finland",
    "amount_eur": 480,
    "currency": "EUR",
    "destination_country": "Finland",
    "destination_bank_type": "Retail",
    "payment_method": "Card",
    "description": "Electronics purchase.",
    "is_new_beneficiary": false,
    "customer_risk_profile": "Low"
  }' | jq
```
