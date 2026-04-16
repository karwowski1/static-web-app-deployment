output "jenkins_sg_id" {
  description = "ID of the Jenkins security group"
  value       = aws_security_group.jenkins_sg.id
}
