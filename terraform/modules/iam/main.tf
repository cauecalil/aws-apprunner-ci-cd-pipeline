module "github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "6.4.0"

  url = "https://token.actions.githubusercontent.com"
}

module "github_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.4.0"

  name = "${var.project_prefix}-github-role"

  enable_github_oidc     = true
  oidc_wildcard_subjects = ["repo:${var.github_organization}/${var.github_repository}:*"]

  policies = {
    github = module.github_policy.arn
  }
}

module "github_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "6.4.0"

  name        = "${var.project_prefix}-github-policy"
  description = "Policy for GitHub Actions CI/CD"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # ECR
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeRepositories"
        ]
        Resource = [
          "arn:aws:ecr:*:*:repository/${var.project_prefix}-*"
        ]
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
        Resource = [
          "arn:aws:apprunner:*:*:service/${var.project_prefix}-*"
        ]
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
          "arn:aws:iam::*:role/${var.project_prefix}-*",
          "arn:aws:iam::*:policy/${var.project_prefix}-*"
        ]
      }
    ]
  })
}
