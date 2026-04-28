output "jenkins_public_ip" {
  value = azurerm_public_ip.jenkins_pip.ip_address
}

output "jenkins_vm_name" {
  value = azurerm_linux_virtual_machine.jenkins_vm.name
}
