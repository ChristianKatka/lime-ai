# input variables
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev or prod)"
  type        = string
}
