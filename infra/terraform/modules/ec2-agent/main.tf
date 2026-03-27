resource "aws_iam_role" "this" {
  name = "${var.project_name}-${var.environment}-ec2-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-agent-role"
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "${var.project_name}-${var.environment}-ec2-policy"
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:*",
        ]
        Resource = var.sqs_queue_arn
      },
      {
        Effect = "Allow"
        Action = [
          "logs:*",
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch log group for the vLLM agent running on EC2
resource "aws_cloudwatch_log_group" "agent" {
  name              = "/ec2/${var.project_name}-${var.environment}-agent"
  retention_in_days = 7
}

# wrapper that lets you attach an IAM role to an EC2 instance.
resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}-${var.environment}-ec2-agent-profile"
  role = aws_iam_role.this.name
}

resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-ec2-security-group"
  description = "EC2 agent security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
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
    Name = "${var.project_name}-${var.environment}-ec2-security-group"
  }
}

resource "aws_instance" "this" {
  ami                    = "ami-0079daae53604f8b6" # ami-name Deep Learning OSS Nvidia Driver AMI GPU PyTorch 2.9 (Amazon Linux 2023) 20260214
  instance_type          = "g6.2xlarge"
  key_name               = "christian-ec2-key-pair"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = aws_iam_instance_profile.this.name

  root_block_device {
    volume_size = 100
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-agent-instance"
  }
}

# Elastic ip addess for ec2, so it doesn´t change every time instance is restarted
resource "aws_eip" "this" {
  instance = aws_instance.this.id

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2-eip"
  }
}
