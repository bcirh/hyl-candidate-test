resource "azurerm_virtual_network" "hylastix_minimal_vnet" {
  name                = "hylastix-minimal-${var.environment}-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = azurerm_resource_group.hylastix_min_rg.location
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name
}

resource "azurerm_subnet" "hylastix_minimal_subnet" {
  name                 = "hylastix-minimal-${var.environment}"
  resource_group_name  = azurerm_resource_group.hylastix_min_rg.name
  virtual_network_name = azurerm_virtual_network.hylastix_minimal_vnet.name
  address_prefixes     = ["192.168.1.0/27"]
}

resource "azurerm_public_ip" "hylastix_minimal_public_ip" {
  name                = "hylastix-minimal-${var.environment}-public-ip"
  location            = azurerm_resource_group.hylastix_min_rg.location
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

data "azurerm_public_ip" "hylastix_minimal_public_ip" {
  name                = azurerm_public_ip.hylastix_minimal_public_ip.name
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name
}

resource "azurerm_network_interface" "hylastix_minimal_nic" {
  name                = "hylastix-minimal-${var.environment}-nic"
  location            = azurerm_resource_group.hylastix_min_rg.location
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.hylastix_minimal_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.hylastix_minimal_public_ip.id
  }
}

resource "azurerm_network_security_group" "hylastix_minimal_nsg" {
  name                = "hylastix-minimal-${var.environment}-nsg"
  location            = azurerm_resource_group.hylastix_min_rg.location
  resource_group_name = azurerm_resource_group.hylastix_min_rg.name

  dynamic "security_rule" {
    for_each = var.ip_restrictions
    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "hylastix_minimal_subnet_nsg_assosiation" {
  subnet_id                 = azurerm_subnet.hylastix_minimal_subnet.id
  network_security_group_id = azurerm_network_security_group.hylastix_minimal_nsg.id
}