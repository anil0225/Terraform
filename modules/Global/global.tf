##
# Module to build the Azure DevOps "seed" configuration
##

# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = var.s3_tfstate_bucket

  # Tells AWS to keep a version history of the state file
  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}

# Build an AWS S3 bucket for logging
resource "aws_s3_bucket" "s3_logging_bucket" {
  bucket = var.s3_logging_bucket_name
  acl    = "private"
}

# Output name of S3 logging bucket back to main.tf
output "s3_logging_bucket_id" {
  value = aws_s3_bucket.s3_logging_bucket.id
}
output "s3_logging_bucket" {
  value = aws_s3_bucket.s3_logging_bucket.bucket
}

# Create an IAM role for CodeBuild to assume
resource "aws_iam_role" "codebuild_sample_iam_role" {
  name = var.codebuild_iam_role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# Output the CodeBuild IAM role
output "codebuild_iam_role_arn" {
  value = aws_iam_role.codebuild_sample_iam_role.arn
}


# Create an IAM role policy for CodeBuild to use implicitly
resource "aws_iam_role_policy" "codebuild_sample_iam_role_policy" {
  name = var.codebuild_iam_role_policy_name
  role = aws_iam_role.codebuild_sample_iam_role.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.s3_logging_bucket.arn}",
        "${aws_s3_bucket.s3_logging_bucket.arn}/*",
        "${aws_s3_bucket.state_bucket.arn}",
        "${aws_s3_bucket.state_bucket.arn}/*",
        "arn:aws:s3:::codepipeline-us-east-1*",
        "arn:aws:s3:::codepipeline-us-east-1*/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:Get*",
        "iam:List*"
      ],
      "Resource": "${aws_iam_role.codebuild_sample_iam_role.arn}"
    },
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.codebuild_sample_iam_role.arn}"
    }
  ]
}
POLICY
}
