# variables.tf - Input variables for the Cloud Resume Challenge

variable "aws_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for the resume site (must be globally unique)"
  type        = string
  default     = "juashua.com"
}

variable "domain_name" {
  description = "Custom domain name for the resume (e.g. juashua.com)"
  type        = string
  default     = "juashua.com"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "cloud-resume-challenge"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}


variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for the resume site (used by CI/CD to invalidate cache)"
  type        = string
  default     = "E1OA146LYDW9G0"
}
