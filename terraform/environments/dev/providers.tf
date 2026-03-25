terraform {
  required_version = "~> 1.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.37.0"
    }
  }

  # backend "s3" {
  #   bucket         = "terraform-state-bucket"
  #   key            = "dev/terraform.tfstate"
  #   region         = "us-east-2"
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.github_repository
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
