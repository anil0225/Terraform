
variable "s3_tfstate_bucket" {
  description = "Name of the S3 bucket used for Terraform state storage"
}
variable "s3_logging_bucket_name" {
  description = "Name of S3 bucket to use for access logging"
}
variable "codebuild_iam_role_name" {
  description = "Name for IAM Role utilized by CodeBuild"
}
variable "codebuild_iam_role_policy_name" {
  description = "Name for IAM policy used by CodeBuild"
}