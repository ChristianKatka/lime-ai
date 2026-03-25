output "security_group_id" {
  value = aws_security_group.ecs.id
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.this.arn
}

output "ecs_service_arn" {
  value = aws_ecs_service.this.id
}
