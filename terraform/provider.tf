terraform {
  required_version = "~> 1.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37.0"
    }
  }

  backend "s3" {
    encrypt = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = "${var.github_organization}/${var.github_repository}"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
