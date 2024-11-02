resource "azurerm_linux_virtual_machine" "hylastix_minimal_vm" {
  name                = "hylastix-min-${var.environment}-vm"
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name
  location            = azurerm_resource_group.hylastix_min_rg.location
  size                = var.vm_size
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.monitoring_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}