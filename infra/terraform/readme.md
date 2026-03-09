```bash
brew install terraform  # macOS
```

### 3. Navigate to Environment ex. dev

```bash
cd infra/terraform/environments/dev
```

### 4. Initialize Terraform

```bash
terraform init
```

This downloads the AWS provider and sets up your workspace.

### 5. Preview Changes

```bash
terraform plan
```

Shows what Terraform will create without actually doing it.

### 6. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` to confirm. Terraform creates all your AWS resources.

### 7. Destroy Infrastructure (when needed)

```bash
terraform destroy
```
