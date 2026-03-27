variable "service_name" {
  type = string
}

variable "container_port" {
  type = string
}

variable "environment_variables" {
  type    = map(string)
  default = {}
}
