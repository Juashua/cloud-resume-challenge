# Cloud Resume Challenge

[![Deploy Frontend](https://github.com/Juashua/cloud-resume-challenge/actions/workflows/deploy-frontend.yml/badge.svg)](https://github.com/Juashua/cloud-resume-challenge/actions/workflows/deploy-frontend.yml)

My implementation of the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) on AWS. A static resume and portfolio site for my cloud security and cybersecurity work, built with production-grade AWS infrastructure, IaC, and CI/CD.

**Live site:** [juashua.com](https://juashua.com)

---

## Architecture

```
User
  |
  v
Route 53 (DNS - juashua.com)
  |
  v
CloudFront (CDN, HTTPS, HTTP->HTTPS redirect, TLSv1.2+)
  |              |
  v              v
 S3 (static    API Gateway (HTTPS /count)
  HTML/CSS/JS)    |
                  v
               Lambda (Python - increment + return count)
                  |
                  v
               DynamoDB (VisitorCount table)
```

### AWS Services Used

| Service | Purpose |
|---|---|
| S3 | Private origin bucket for static site assets |
| CloudFront | CDN with HTTPS, OAC, HTTP-to-HTTPS redirect |
| ACM | Public TLS certificate (us-east-1) for CloudFront |
| Route 53 | Hosted zone + alias A record pointing to CloudFront |
| API Gateway | Public HTTPS endpoint for the visitor counter |
| Lambda | Serverless function to read/increment visitor count |
| DynamoDB | On-demand table storing visitor count by route |
| IAM | Least-privilege roles for Lambda and CI/CD |

---

## Repository Structure

```
cloud-resume-challenge/
  README.md
  LICENSE
  .gitignore               # Terraform-aware gitignore
  frontend/
    index.html             # Resume HTML
    styles.css             # Dark-theme styling
    script.js              # Visitor counter fetch call
  infra/
    main.tf                # S3, CloudFront, ACM, DynamoDB resources
    variables.tf           # Input variables (region, domain, bucket)
    outputs.tf             # CloudFront ID, S3 bucket, ACM ARN
  .github/
    workflows/
      deploy-frontend.yml  # S3 sync + CloudFront invalidation on push
```

---

## CI/CD

On every push to `main` that changes `frontend/**`:

1. **Checkout** source
2. **Configure AWS credentials** via GitHub Secrets
3. **`aws s3 sync`** frontend/ to S3 with `--delete`
4. **`aws cloudfront create-invalidation`** to flush the CDN cache

### Required GitHub Secrets

| Secret | Value |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user access key (CI/CD deploy only permissions) |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `S3_BUCKET_NAME` | Name of the S3 resume bucket |
| `CLOUDFRONT_DISTRIBUTION_ID` | CloudFront distribution ID (from Terraform output) |

---

## Infrastructure Deployment

```bash
cd infra
terraform init
terraform plan
terraform apply
```

Update `variables.tf` with your domain and bucket name before applying.

---

## What I Built / Key Highlights

- Secure static hosting: S3 bucket is **private** — CloudFront accesses it via **Origin Access Control (OAC)**, never a public bucket
- HTTPS enforced: ACM certificate (us-east-1) attached to CloudFront, HTTP redirected to HTTPS
- Custom domain: Route 53 alias record pointing to the CloudFront distribution
- Serverless visitor counter: JavaScript on the page calls API Gateway → Lambda → DynamoDB
- Infrastructure as Code: All AWS resources defined in Terraform with remote state in S3
- Automated deployments: GitHub Actions deploys on every push with no manual steps
- Least-privilege IAM: CI/CD role scoped to `s3:PutObject`, `s3:DeleteObject`, `cloudfront:CreateInvalidation` only

---

## Blog Post

Write-up coming soon on Medium.

---

## License

MIT
