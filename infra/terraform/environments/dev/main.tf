# calls your modules
module "sqs" {
  source = "../../modules/sqs"

  project_name = var.project_name
  environment  = var.environment
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
}

module "ec2_agent" {
  source = "../../modules/ec2-agent"

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  sqs_queue_arn    = module.sqs.queue_arn
}

module "ecs_backend" {
  source = "../../modules/ecs-backend"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  sqs_queue_arn     = module.sqs.queue_arn
  sqs_queue_url     = module.sqs.queue_url
  db_username       = "christian"
  db_password       = var.db_password
  postgres_db_url   = module.rds.db_hostname
}

module "rds" {
  source = "../../modules/rds"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_password           = var.db_password
  ec2_security_group_id = module.ec2_agent.security_group_id
  ecs_security_group_id = module.ecs_backend.security_group_id
}

module "github_oidc" {
  source = "../../modules/github-oidc"

  project_name       = var.project_name
  environment        = var.environment
  ecr_repository_arn = module.ecs_backend.ecr_repository_arn
  ecs_service_arn    = module.ecs_backend.ecs_service_arn
}



