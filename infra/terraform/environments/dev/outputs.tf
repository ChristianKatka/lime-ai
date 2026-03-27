# useful outputs

output "rds_endpoint" {
  value = module.rds.db_hostname
}

output "sqs_queue_url" {
  value = module.sqs.queue_url
}

output "github_actions_role_arn" {
  value = module.github_oidc.role_arn
}

output "cloudfront_domain" {
  value = module.frontend.cloudfront_domain
}

output "s3_bucket_name" {
  value = module.frontend.s3_bucket_name
}
