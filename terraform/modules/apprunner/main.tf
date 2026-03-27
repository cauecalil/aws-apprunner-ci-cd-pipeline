resource "aws_apprunner_service" "apprunner" {
  service_name = var.service_name

  source_configuration {
    auto_deployments_enabled = false

    image_repository {
      image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"

      image_configuration {
        port                          = tostring(var.container_port)
        runtime_environment_variables = var.environment_variables
      }
    }
  }

  lifecycle {
    ignore_changes = [
      source_configuration[0].image_repository[0].image_identifier,
      source_configuration[0].image_repository[0].image_repository_type,
      source_configuration[0].image_repository[0].image_configuration[0].runtime_environment_variables,
      source_configuration[0].authentication_configuration
    ]
  }
}
