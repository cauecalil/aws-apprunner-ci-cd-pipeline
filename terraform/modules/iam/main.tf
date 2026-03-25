# Github OIDC Provider
module "oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.4.0"

  url = "https://token.actions.githubusercontent.com"
}

# GitHub Actions Policy
module "github_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.4.0"

  name        = "${var.name_prefix}-github-policy"
  description = "Policy for GitHub Actions CI/CD"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories",
          "ecr:CreateRepository"
        ]
        Resource = "*"
      },
      # AppRunner
      {
        Effect = "Allow"
        Action = [
          "apprunner:CreateService",
          "apprunner:UpdateService",
          "apprunner:DeleteService",
          "apprunner:DescribeService",
          "apprunner:ListServices"
        ]
        Resource = "*"
      },
      # IAM
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy"
        ]
        Resource = [
          "arn:aws:iam::*:role/${var.name_prefix}-*",
          "arn:aws:iam::*:policy/${var.name_prefix}-*"
        ]
      },
      # PassRole
      {
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::*:role/${var.name_prefix}-*"
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "apprunner.amazonaws.com"
          }
        }
      }
    ]
  })
}

# GitHub Actions Role (OIDC)
module "github_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.4.0"

  name = "${var.name_prefix}-github-role"

  enable_github_oidc = true

  oidc_wildcard_subjects = [
    "repo:${var.github_repository}:ref:refs/heads/main",
  ]

  policies = {
    github = module.github_policy.arn
  }
}

# AppRunner Instance Role (Runtime)
module "instance_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.4.0"

  name = "${var.name_prefix}-instance-role"

  trust_policy_permissions = {
    AppRunnerTasks = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["tasks.apprunner.amazonaws.com"]
      }]
    }
  }
}

# AppRunner Access Role (ECR Pull)
module "access_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.4.0"

  name = "${var.name_prefix}-access-role"

  trust_policy_permissions = {
    AppRunnerBuild = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = ["build.apprunner.amazonaws.com"]
      }]
    }
  }

  policies = {
    ECRReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}
