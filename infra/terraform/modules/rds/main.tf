resource "aws_db_subnet_group" "this" {
  name = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = [
    "subnet-0c1b481b3120dff79",
    "subnet-0b278bc7a7ab8caa1"
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "RDS security group"
  vpc_id      = "vpc-08c89629fb4fb521a"

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "${var.project_name}-${var.environment}-postgresdb"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = "db.t4g.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  username               = "christian"
  password               = ""
  db_name                = "postgres"
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  tags = {
    Name = "${var.project_name}-${var.environment}-postgresdb"
  }
}
