# CodeStar Connection to GitHub
resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project_name}-${var.environment}-github"
  provider_type = "GitHub"

  tags = {
    Name = "${var.project_name}-${var.environment}-github-connection"
  }
}

# S3 bucket for pipeline artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.project_name}-${var.environment}-pipeline-artifacts"
  force_destroy = true

  tags = {
    Name = "${var.project_name}-${var.environment}-pipeline-artifacts"
  }
}

# CodeBuild IAM Role
resource "aws_iam_role" "codebuild" {
  name = "${var.project_name}-${var.environment}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-codebuild-role"
  }
}

resource "aws_iam_role_policy" "codebuild" {
  name = "${var.project_name}-${var.environment}-codebuild-policy"
  role = aws_iam_role.codebuild.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject"]
        Resource = "${aws_s3_bucket.artifacts.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
        ]
        Resource = var.ecr_repository_arn
      },
      {
        Effect = "Allow"
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices",
        ]
        Resource = var.ecs_service_arn
      },
      {
        # SSM Run Command to build n deploy vLLM agent on EC2
        Effect = "Allow"
        Action = [
          "ssm:SendCommand",
          "ssm:GetCommandInvocation",
        ]
        Resource = "*"
      },
      {
        # Upload frontend build to S3
        Effect = "Allow"
        Action = ["s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.frontend_bucket_name}",
          "arn:aws:s3:::${var.frontend_bucket_name}/*"
        ]
      },
      {
        # Invalidate CloudFront cache after frontend deploy
        Effect   = "Allow"
        Action   = ["cloudfront:CreateInvalidation"]
        Resource = "*"
      }
    ]
  })
}

# CodeBuild Project - builds and pushes Docker image
resource "aws_codebuild_project" "backend" {
  name         = "${var.project_name}-${var.environment}-backend-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true # needed for docker build

    environment_variable {
      name  = "ECR_REPO_URI"
      value = var.ecr_repository_url
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "802026442401"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "backend/buildspec.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-build"
  }
}

# CodeBuild Project - deploys to ECS (force new deployment)
resource "aws_codebuild_project" "deploy" {
  name         = "${var.project_name}-${var.environment}-backend-deploy"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        build:
          commands:
            - echo Deploying to ECS...
            - aws ecs update-service --cluster ${var.project_name}-${var.environment}-cluster --service ${var.project_name}-${var.environment}-backend-service --force-new-deployment --region eu-north-1
            - echo Deploy triggered successfully
    EOF
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-deploy"
  }
}

# CodeBuild Project - builds and deploys vLLM agent on EC2 via SSM
resource "aws_codebuild_project" "deploy_agent" {
  name         = "${var.project_name}-${var.environment}-vLLM-agent-build-n-deploy"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "EC2_INSTANCE_ID"
      value = var.ec2_instance_id
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        build:
          commands:
            - echo Deploying vLLM agent to EC2...
            - |
              COMMAND_ID=$(aws ssm send-command \
                --instance-ids $EC2_INSTANCE_ID \
                --document-name "AWS-RunShellScript" \
                --parameters 'commands=["cd /home/ec2-user/projects/lime-ai && git pull && cd vLLM && docker compose up -d --build agent && docker image prune -f"]' \
                --region eu-north-1 \
                --query "Command.CommandId" \
                --output text)
            - echo "SSM Command ID $COMMAND_ID"
            - echo Waiting for command to complete...
            - aws ssm wait command-executed --command-id $COMMAND_ID --instance-id $EC2_INSTANCE_ID --region eu-north-1 || true
            - aws ssm get-command-invocation --command-id $COMMAND_ID --instance-id $EC2_INSTANCE_ID --region eu-north-1 --query "[Status,StandardOutputContent,StandardErrorContent]"
    EOF
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-vLLM-agent-deploy"
  }
}

# CodeBuild Project - builds React frontend
resource "aws_codebuild_project" "frontend_build" {
  name         = "${var.project_name}-${var.environment}-frontend-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "frontend/buildspec.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-frontend-build"
  }
}

# CodeBuild Project - deploys frontend to S3 and invalidates CloudFront
resource "aws_codebuild_project" "frontend_deploy" {
  name         = "${var.project_name}-${var.environment}-frontend-deploy"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOF
      version: 0.2
      phases:
        build:
          commands:
            - echo Deploying frontend to S3...
            - aws s3 sync frontend/dist/ s3://${var.frontend_bucket_name} --delete
            - echo Invalidating CloudFront cache...
            - aws cloudfront create-invalidation --distribution-id ${var.cloudfront_distribution_id} --paths "/*"
    EOF
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-frontend-deploy"
  }
}

# CodePipeline IAM Role
resource "aws_iam_role" "codepipeline" {
  name = "${var.project_name}-${var.environment}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-codepipeline-role"
  }
}

resource "aws_iam_role_policy" "codepipeline" {
  name = "${var.project_name}-${var.environment}-codepipeline-policy"
  role = aws_iam_role.codepipeline.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:PutObject", "s3:GetBucketVersioning"]
        Resource = ["${aws_s3_bucket.artifacts.arn}", "${aws_s3_bucket.artifacts.arn}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["codestar-connections:UseConnection"]
        Resource = aws_codestarconnections_connection.github.arn
      },
      {
        Effect   = "Allow"
        Action   = ["codebuild:StartBuild", "codebuild:BatchGetBuilds"]
        Resource = [aws_codebuild_project.backend.arn, aws_codebuild_project.deploy.arn, aws_codebuild_project.deploy_agent.arn, aws_codebuild_project.frontend_build.arn, aws_codebuild_project.frontend_deploy.arn]
      },
      {
        Effect   = "Allow"
        Action   = ["ecs:*"]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["iam:PassRole"]
        Resource = "*"
      }
    ]
  })
}

# The Pipeline - manual trigger only (no auto-deploy on push)
resource "aws_codepipeline" "pipeline" {
  name     = "${var.project_name}-${var.environment}-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  pipeline_type = "V2"

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Pull-GitHub-Repo"

    action {
      name             = "Pull-lime-ai-master"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "ChristianKatka/lime-ai"
        BranchName       = "master"
        DetectChanges    = false # manual trigger only
      }
    }
  }

  stage {
    name = "Build-Backend-Image-Push-ECR"

    action {
      name            = "Build-Backend-Docker-Image"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.backend.name
      }
    }
  }

  stage {
    name = "Deploy-Backend-to-ECS"

    action {
      name            = "Force-New-ECS-Deployment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.deploy.name
      }
    }
  }

  stage {
    name = "Deploy-vLLM-Agent-to-EC2"

    action {
      name            = "SSM-Pull-Rebuild-Agent"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.deploy_agent.name
      }
    }
  }

  stage {
    name = "Build-Frontend"

    action {
      name            = "Build-React-App"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.frontend_build.name
      }
    }
  }

  stage {
    name = "Deploy-Frontend-to-S3"

    action {
      name            = "Sync-S3-Invalidate-CloudFront"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ProjectName = aws_codebuild_project.frontend_deploy.name
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-pipeline"
  }
}
