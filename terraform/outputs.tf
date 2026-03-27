output "apprunner_service_url" {
  value = module.apprunner.service_url
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "github_role_arn" {
  value = module.iam.github_role_arn
}
