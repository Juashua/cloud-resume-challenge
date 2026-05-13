# outputs.tf - Useful values after terraform apply

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.resume.bucket
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation in CI/CD)"
  value       = aws_cloudfront_distribution.resume.id
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.resume.domain_name
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.resume.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for visitor counter"
  value       = aws_dynamodb_table.visitor_count.name
}
