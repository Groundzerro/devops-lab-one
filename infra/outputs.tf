# infra/outputs.tf

output "jenkins_master_public_ip" {
  value       = module.jenkins_master.public_ip
  description = "Public IP of Jenkins master"
}

output "tomcat_public_ip" {
  value       = module.tomcat.public_ip
  description = "Public IP of Tomcat server"
}
