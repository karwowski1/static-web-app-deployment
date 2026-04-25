output "website_url" {
  description = "Static website URL"
  value       = "https://${module.cdn.cdn_endpoint_hostname}"
}
