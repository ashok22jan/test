resource "azurerm_resource_group" "labs" {
  name     = "devg_1"
  location = "eastus"
}

resource "azurerm_storage_account" "SA" {
  name                     = "ashokdev098765"
  resource_group_name      = azurerm_resource_group.labs.name
  location                 = azurerm_resource_group.labs.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "training"
  }
}

resource "azurerm_virtual_network" "vNet_dev" {
  name                = "dev-network"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.labs.name
  location            = azurerm_resource_group.labs.location
}
resource "azurerm_subnet" "dev_Subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.labs.name
  virtual_network_name = azurerm_virtual_network.vNet_dev.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "dev_Subnet2" {
  name                 = "External"
  resource_group_name  = azurerm_resource_group.labs.name
  virtual_network_name = azurerm_virtual_network.vNet_dev.name
  address_prefixes     = ["10.0.0.128/25"]
}
resource "azurerm_network_interface" "dev_nic" {
  name                = "dev-nic"
  location            = azurerm_resource_group.labs.location
  resource_group_name = azurerm_resource_group.labs.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.dev_Subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}