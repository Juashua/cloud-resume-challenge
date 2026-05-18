# route53.tf  -  Route 53 DNS records for juashua.com
# References the existing hosted zone (created manually or via Namecheap NS delegation)
# Manages:
#   1. ACM certificate DNS validation records
#   2. Root domain A record  -> CloudFront (alias)
#   3. www subdomain A record -> CloudFront (alias)

# -------------------------------------------------------
# Data source: look up the existing hosted zone by name
# -------------------------------------------------------
data "aws_route53_zone" "resume" {
  name         = var.domain_name # "juashua.com"
  private_zone = false
}

# -------------------------------------------------------
# ACM certificate DNS validation records
# (Terraform creates these so ACM can auto-validate)
# -------------------------------------------------------
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.resume.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.resume.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]

  allow_overwrite = true
}

# Wait for certificate to be issued before proceeding
resource "aws_acm_certificate_validation" "resume" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.resume.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# -------------------------------------------------------
# Root domain: juashua.com -> CloudFront (A alias)
# -------------------------------------------------------
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.resume.zone_id
  name    = var.domain_name # "juashua.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume.domain_name
    zone_id                = aws_cloudfront_distribution.resume.hosted_zone_id
    evaluate_target_health = false
  }
}

# -------------------------------------------------------
# www subdomain: www.juashua.com -> CloudFront (A alias)
# -------------------------------------------------------
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.resume.zone_id
  name    = "www.${var.domain_name}" # "www.juashua.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.resume.domain_name
    zone_id                = aws_cloudfront_distribution.resume.hosted_zone_id
    evaluate_target_health = false
  }
}

# -------------------------------------------------------
# Output the hosted zone ID (useful for reference)
# -------------------------------------------------------
output "route53_zone_id" {
  description = "Route 53 hosted zone ID for juashua.com"
  value       = data.aws_route53_zone.resume.zone_id
}
