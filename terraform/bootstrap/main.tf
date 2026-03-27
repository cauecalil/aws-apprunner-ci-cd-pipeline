module "tf_state_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.11.0"

  bucket = "${var.project_name}-tfstate"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true
}

module "tf_state_lock_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 5.5.0"

  name     = "${var.project_name}-tfstate-lock"
  hash_key = "LockID"

  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  billing_mode = "PAY_PER_REQUEST"

  deletion_protection_enabled = false
}
