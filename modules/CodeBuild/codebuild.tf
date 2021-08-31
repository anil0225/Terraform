resource "aws_codebuild_project" "codebuild_project_terraform_plan" {
  name          = var.codebuild_project_terraform_plan_name
  description   = "Terraform codebuild project"
  build_timeout = "5"
  service_role  = var.codebuild_iam_role_arn


  cache {
    type     = "S3"
    location = var.s3_logging_bucket
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "TERRAFORM_VERSION"
      value = "0.12.16"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${var.s3_logging_bucket_id}/${var.codebuild_project_terraform_plan_name}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/anil0225/tempcodebuild.git"
    git_clone_depth = 1

    auth {
      type     = "OAUTH"
      resource = aws_codebuild_source_credential.github_creds.arn
    }

    git_submodules_config {
      fetch_submodules = true
    }
  }
  tags = {
    Terraform = "true"
  }
}

resource "aws_codebuild_source_credential" "github_creds" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "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"
}
