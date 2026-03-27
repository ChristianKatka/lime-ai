variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "ecs_service_arn" {
  type = string
}

variable "ec2_instance_id" {
  type = string
}

variable "frontend_bucket_name" {
  type = string
}

variable "cloudfront_distribution_id" {
  type = string
}
