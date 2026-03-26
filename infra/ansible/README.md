# Ansible - EC2 Agent Setup

This is for initial setup of EC2 instance
vLLM updates will be handled via github actions

Automates the EC2 instance setup for running the vLLM agent.

## Prerequisites

```bash
brew install ansible
```

## SSH Config

Make sure your `~/.ssh/config` has the EC2 host configured:

```
Host lime-ai-dev-llm-ec2
  HostName <ELASTIC_IP_FROM_AWS_CONSOLE>
  User ec2-user
  IdentityFile ~/path/to/christian-ec2-key-pair.pem
  IdentitiesOnly yes
```

## Before running

Get these values from terraform:

```bash
cd infra/terraform/environments/dev
terraform output
```

You'll need `rds_endpoint` and `sqs_queue_url` from the output.

## Run

```bash
cd infra/ansible
ansible-playbook -i inventory.ini setup-ec2.yml
```

It will prompt you for:

- DB password
- HuggingFace token
- SQS queue URL (from terraform output)
- RDS hostname (from terraform output)

## What it does

1. Installs PostgreSQL client
2. Creates the `risk_assessments` table (if not exists)
3. Installs docker compose and buildx
4. Clones the repo
5. Creates `.env` file with your secrets
6. Starts vLLM + agent with `docker compose up -d`

## Re-running

Safe to run multiple times. It skips already completed steps.
To update the agent code, just run it again — it will `git pull` and restart.
