variable "project_name" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "region" {
  type = string
}

variable "environment" {
  type = string
}

variable "port" {
  type    = number
  default = 3000
}
