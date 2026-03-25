locals {
  project_name_environment = "${var.project_name}-${var.environment}"
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = local.project_name_environment
}

module "iam" {
  source = "../../modules/iam"

  name_prefix       = local.project_name_environment
  github_repository = var.github_repository
}

module "apprunner" {
  source = "../../modules/apprunner"

  depends_on = [
    module.iam
  ]

  service_name = local.project_name_environment
  container_port = 3000
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn

  # this is what allows CI/CD deployment
  app_image_uri = var.app_image_uri

  environment_variables = {
    APP_ENV = var.environment
    PORT    = "3000"
  }
}
