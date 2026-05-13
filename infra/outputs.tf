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

output "api_gateway_invoke_url" {
  description = "API Gateway invoke URL for the visitor counter - paste this into frontend/script.js"
  value       = "${aws_apigatewayv2_stage.visitor_counter.invoke_url}/count"
}

output "lambda_function_name" {
  description = "Lambda function name for the visitor counter"
  value       = aws_lambda_function.visitor_counter.function_name
}

output "lambda_iam_role_arn" {
  description = "ARN of the least-privilege Lambda execution IAM role"
  value       = aws_iam_role.lambda_exec.arn
}
