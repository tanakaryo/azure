resource "azurerm_virtual_network" "example_network" {
  name = "example-network"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example_subnet" {
    name = "example-subnet"
    resource_group_name = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example_network.name
    address_prefixes = [ "10.0.2.0/24" ]
}