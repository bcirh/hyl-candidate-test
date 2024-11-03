output "hylastix_vm_public_ip" {
  description = "VM Public IP"
  value       = azurerm_public_ip.hylastix_minimal_public_ip.ip_address
}