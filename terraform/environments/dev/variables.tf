variable "project_name" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "app_image_uri" {
  type        = string
  default     = "public.ecr.aws/aws-containers/hello-app-runner:latest" # Bootstrap fallback
  description = "Overridden by CI/CD pipeline"
}
