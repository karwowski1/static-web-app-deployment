output "web_instance_id" {
  value = aws_instance.web-1.id
}
output "api_instance_id" {
  value = aws_instance.api-1.id
}
output "worker_instance_id" {
  value = aws_instance.worker-1.id
}
