output "website_url" {
  description = "The CloudFront URL to access the website"
    value       = module.cloudfront.cloudfront_domain_name
}