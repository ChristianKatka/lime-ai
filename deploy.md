# First run terraform init plan apply

GITHUB ACTIONS

github uses OIDC (OpenID Connect)
and we created iam identity provider and via that github action can assume role that can acces ecs to force new deployment and push to ecr

Goto github
Go to your repo on GitHub: github.com/ChristianKatka/lime-ai
Click "Settings" tab (top right)
Left sidebar → "Secrets and variables" → click "Actions"
Click "New repository secret" button
Name: AWS_ROLE_ARN
Secret: paste the ARN from terraform output github_actions_role_arn (arn:aws:iam::802026442401:role/christian-lime-ai-dev-github-actions-role)
Click "Add secret"
That's it. The workflow reads it with ${{ secrets.AWS_ROLE_ARN }}.

```bash



# Crab the outputs:
rds_endpoint = "christian-lime-ai-dev-postgresdb.cvkj09hn6us5.eu-north-1.rds.amazonaws.com"
sqs_queue_url = "https://sqs.eu-north-1.amazonaws.com/802026442401/christian-lime-ai-dev-transactions-sqs"

# open ~/.ssh/config

Host lime-llm-ec2
  HostName 13.62.34.37 # PÄIVITÄ IP OSOTE from aws console elastic IPs
  User ec2-user
  IdentityFile ~/Documents/My/myProjects/2026/ec2-vllm/christian-ec2-key-pair.pem
  IdentitiesOnly yes

# Then run to connect
ssh lime-ai-dev-llm-ec2

# Install psql
sudo dnf install -y postgresql16

# Connect
psql -h christian-lime-ai-dev-postgresdb.cvkj09hn6us5.eu-north-1.rds.amazonaws.com -U christian -d postgres

CREATE TABLE risk_assessments (
    id UUID PRIMARY KEY,
    time_stamp TIMESTAMPTZ NOT NULL,
    summary TEXT,
    risk_level TEXT,
    risk_score INTEGER,
    risk_categories TEXT[],
    red_flags TEXT[],
    missing_information TEXT[],
    recommended_actions TEXT[],
    confidence TEXT
);

exit


mkdir projects
cd projects
git clone https://github.com/ChristianKatka/lime-ai.git
cd lime-ai
cd vLLM

# CREATE ENV FILE INSIDE vLLM

cat << 'EOF' > .env

<Copy-from-notes>

EOF


# THEN DOCKER COMPOSE NEED TO BE INSTALLED MANUALLY
sudo mkdir -p /usr/local/lib/docker/cli-plugins

sudo curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-$(uname -m)" \
    -o /usr/local/lib/docker/cli-plugins/docker-compose

sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

docker compose version

# Update buildx that docker compose requires, and grab latest version
BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)
sudo curl -SL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o /usr/local/lib/docker/cli-plugins/docker-buildx
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx
docker buildx version


# THEN START THE AGENT and vLLM
docker compose up -d

# wait vLLM to start, -> wait for this log -> Application startup complete.
docker compose logs -f --tail=50 vllm
# then check agent is running
docker compose logs -f agent


# FROM YOUR OWN LAPTOP SO DONT BE INSIDE EC2.
# DEPLOY BACKEND ECS
cd ..
cd backend

# CREATE .env
cat << 'EOF' > .env

<Copy-from-notes>

EOF

# REMEMBER AWS CREDENTIALS IN TERMINAL
# check push commands from ecr view push commands and
# replace step 2 (the docker build) with
docker compose build
# After pushing the image to ecr
# force new deployment to ecs so it pulls latest image from ecr
aws ecs update-service --cluster christian-lime-ai-dev-cluster --service christian-lime-ai-dev-backend-service --force-new-deployment --region eu-north-1
# Force youll see two tasks running for a sec, just wait


# Then go to ecs -> service -> task and copy public ip address
16.171.175.244

curl http://16.171.175.244:8001/health

curl -X POST http://16.171.175.244:8001/transactions -H "Content-Type: application/json" -d '    {
    "transaction_id": "TX-1004",
    "timestamp": "2026-02-17T12:33:55Z",
    "customer_id": "CUST-55478",
    "customer_country": "Sweden",
    "amount_eur": 72000,
    "currency": "EUR",
    "destination_country": "Russia",
    "destination_bank_type": "Unknown",
    "payment_method": "Wire Transfer",
    "description": "Equipment purchase.",
    "is_new_beneficiary": true,
    "customer_risk_profile": "Medium"
  }'

curl http://16.171.175.244:8001/risk


# NEXT TIME CONTINUE TO AUTOMATE vLLM Agent deployment with github actions

```
