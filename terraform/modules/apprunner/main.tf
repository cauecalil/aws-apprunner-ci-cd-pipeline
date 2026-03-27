module "apprunner" {
  source  = "terraform-aws-modules/app-runner/aws"
  version = "1.2.2"

  service_name = var.service_name

  source_configuration = {
    auto_deployments_enabled = false

    image_repository = {
      image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"

      image_configuration = {
        port                          = var.container_port
        runtime_environment_variables = var.environment_variables
      }
    }
  }
}
