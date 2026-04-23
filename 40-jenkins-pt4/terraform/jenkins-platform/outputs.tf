output "jenkins_public_ip" {
  description = "Public IP of the Jenkins Controller"
  value       = module.jenkins.jenkins_public_ip
}

output "jenkins_agent_ci_private_ip" {
  description = "Private IP of the Jenkins CI Agent"
  value       = module.jenkins.jenkins_agent_ci_private_ip
}

output "jenkins_agent_infra_private_ip" {
  description = "Private IP of the Jenkins Infra Agent"
  value       = module.jenkins.jenkins_agent_infra_private_ip
}
