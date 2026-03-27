locals {
  project_prefix = "${var.project_name}-${var.environment}"
}

module "ecr" {
  source = "./modules/ecr"

  repository_name = local.project_prefix
}

module "apprunner" {
  source = "./modules/apprunner"

  service_name = local.project_prefix

  container_port = var.port

  environment_variables = {
    APP_ENV = var.environment
    PORT    = var.port
  }
}

module "iam" {
  source = "./modules/iam"

  project_prefix      = local.project_prefix
  github_organization = var.github_organization
  github_repository   = var.github_repository
  s3_bucket           = "${var.project_name}-tfstate"
  dynamodb_table      = "${var.project_name}-tfstate-lock"
}
