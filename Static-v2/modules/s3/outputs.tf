output "bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "bucket_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}

output "logs_bucket_domain_name" {
  description = "The domain name of the logs S3 bucket"
  value       = aws_s3_bucket.logs_bucket.bucket_domain_name
}