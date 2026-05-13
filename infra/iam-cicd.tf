# iam-cicd.tf
# Least-privilege IAM policy for the github-actions-cicd user
# This user is used by GitHub Actions to sync frontend to S3 and invalidate CloudFront.
# NOTE: Apply with `terraform apply` after setting var.bucket_name and var.cloudfront_distribution_id

data "aws_iam_user" "cicd" {
  user_name = "github-actions-cicd"
}

resource "aws_iam_user_policy" "cicd_s3_cloudfront" {
  name = "github-actions-cicd-policy"
  user = data.aws_iam_user.cicd.user_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3BucketAccess"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cloudfront_distribution_id}"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
