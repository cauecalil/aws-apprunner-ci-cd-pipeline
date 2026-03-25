locals {
  is_public_image = startswith(var.app_image_uri, "public.ecr.aws")
}

module "apprunner" {
  source  = "terraform-aws-modules/app-runner/aws"
  version = "1.2.2"

  service_name = var.service_name

  source_configuration = {
    auto_deployments_enabled = false

    authentication_configuration = local.is_public_image ? {} : {
      access_role_arn = var.access_role_arn
    }

    image_repository = {
      image_identifier      = var.app_image_uri
      image_repository_type = local.is_public_image ? "ECR_PUBLIC" : "ECR"

      image_configuration = {
        port = tostring(var.container_port)

        runtime_environment_variables = var.environment_variables
      }
    }
  }

  instance_configuration = {
    instance_role_arn = var.instance_role_arn
  }
}
