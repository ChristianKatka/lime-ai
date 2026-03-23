# ECR - stores backend Docker image
resource "aws_ecr_repository" "this" {
  name                 = "${var.project_name}-${var.environment}/backend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr"
  }
}

# ECS Cluster - Fargate only (serverless)
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster"
  }
}

# ECS Service Security Group - direct access on port 8001
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "ECS service security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "Backend API"
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-sg"
  }
}

# ECS Task Role - permissions for the app itself (SQS access)
resource "aws_iam_role" "ecs_task" {
  name = "${var.project_name}-${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-task-role"
  }
}

resource "aws_iam_role_policy" "ecs_sqs" {
  name = "${var.project_name}-${var.environment}-ecs-sqs-policy"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sqs:*"]
      Resource = var.sqs_queue_arn
    }]
  })
}

# ECS Task Execution Role - lets ECS pull images from ECR
resource "aws_iam_role" "ecs_execution" {
  name = "${var.project_name}-${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_logs" {
  name = "${var.project_name}-${var.environment}-ecs-logs-policy"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["logs:CreateLogGroup"]
      Resource = "*"
    }]
  })
}

# ECS Task Definition
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-${var.environment}-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([{
    name      = "backend"
    image     = "${aws_ecr_repository.this.repository_url}:latest"
    essential = true
    portMappings = [{
      containerPort = 8001
      protocol      = "tcp"
    }]
    environment = [
      { name = "DB_USERNAME", value = var.db_username },
      { name = "DB_PASSWORD", value = var.db_password },
      { name = "SQS_QUEUE_URL", value = var.sqs_queue_url },
      { name = "POSTGRES_DB_URL", value = var.postgres_db_url }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.project_name}-${var.environment}-backend"
        "awslogs-region"        = "eu-north-1"
        "awslogs-stream-prefix" = "backend"
        "awslogs-create-group"  = "true"
      }
    }
  }])

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-task"
  }
}

# ECS Service
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-${var.environment}-backend-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-service"
  }
}
