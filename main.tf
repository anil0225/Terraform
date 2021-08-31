
terraform {
  required_version = ">= 0.12.26"
}

provider "aws" {
  region  = var.region
}


module "global" {
  source="./modules/Global"
  s3_tfstate_bucket="codebuild-tfstate"
  s3_logging_bucket_name="codebuild-tfbucket"
  codebuild_iam_role_name="codebuild-sample-role"
  codebuild_iam_role_policy_name="codebuild-sample-role-policy"
}

module "codebuild" {
  source                                 = "./modules/CodeBuild"
  codebuild_project_terraform_plan_name  = "TerraformPlan"
  s3_logging_bucket_id                   = module.global.s3_logging_bucket_id
  codebuild_iam_role_arn                 = module.global.codebuild_iam_role_arn
  s3_logging_bucket                      = module.global.s3_logging_bucket
}
