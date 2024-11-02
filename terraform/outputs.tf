output "monitoring_vm_public_ip" {
  description = "Monitoring VM Public IP"
  value       = azurerm_public_ip.monitoring_public_ip.ip_address
}