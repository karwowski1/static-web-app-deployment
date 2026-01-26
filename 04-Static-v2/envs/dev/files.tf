resource "aws_s3_object" "index_html" {
  bucket       = module.s3_website.bucket_id
  key          = "index.html"
  source       = "../../src/index.html"
  content_type = "text/html"
  etag         = filemd5("../../src/index.html")
}

resource "aws_s3_object" "error_html" {
  bucket       = module.s3_website.bucket_id
  key          = "error.html"
  source       = "../../src/error.html"
  content_type = "text/html"
  etag         = filemd5("../../src/error.html")
}
