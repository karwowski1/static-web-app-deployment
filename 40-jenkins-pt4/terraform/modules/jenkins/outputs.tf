output "jenkins_sg_id" {
  description = "ID of the Jenkins security group"
  value       = aws_security_group.jenkins_sg.id
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins Controller"
  value       = aws_instance.jenkins_controller.public_ip
}

output "jenkins_agent_ci_private_ip" {
  description = "Private IP of the Jenkins CI Agent"
  value       = aws_instance.agent_ci.private_ip
}

output "jenkins_agent_infra_private_ip" {
  description = "Private IP of the Jenkins Infra Agent"
  value       = aws_instance.agent_infra.private_ip
}
