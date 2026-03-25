variable "service_name" {
  type = string
}

variable "container_port" {
  type = number
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}

variable "instance_role_arn" {
  type = string
}

variable "access_role_arn" {
  type = string
}

variable "app_image_uri" {
  type    = string
  default = "public.ecr.aws/aws-containers/hello-app-runner:latest"
}
