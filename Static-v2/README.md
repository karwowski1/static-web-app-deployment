# Static Web App Deployment v2 (Terraform)

This project provisions a secure static website, which returns the string Hello World, hosting architecture on AWS using Terraform.

## Architecture
- **AWS S3:** Private bucket for storing HTML/CSS/JS files.
- **AWS CloudFront:** CDN for global distribution and HTTPS termination.
- **Security:** S3 Bucket Policy + OAC (Origin Access Control) restricts access only to CloudFront.

## 📂 Project Structure
```text
Static-v2/
├── envs/
│   └── dev/             # Environment specific configuration (main.tf)
├── modules/
│   ├── s3/              # S3 Bucket Module
│   └── cloudfront/      # CloudFront Distribution Module
└── src/                 # Website source code (index.html)