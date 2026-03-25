

# This will be created in IAM -> Identity providers
# GitHub OIDC provider - lets GitHub Actions assume IAM roles without access keys
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's OIDC SSL certificate fingerprint, same for everyone

  tags = {
    Name = "${var.project_name}-${var.environment}-github-oidc"
  }
}

# IAM role that GitHub Actions assumes
resource "aws_iam_role" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
        }
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:ChristianKatka/lime-ai:*"
        }
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-github-actions-role"
  }
}

# Permissions for GitHub Actions: push to ECR + update ECS
resource "aws_iam_role_policy" "github_actions" {
  name = "${var.project_name}-${var.environment}-github-actions-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:*",
        ]
        Resource = var.ecr_repository_arn
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:*",
        ]
        Resource = var.ecs_service_arn
      }
    ]
  })
}
