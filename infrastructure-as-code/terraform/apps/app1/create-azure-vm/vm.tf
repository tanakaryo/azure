resource "azurerm_network_interface" "example_interface" {
    name = "example-interface"
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    ip_configuration {
      name = "configuration1"
      subnet_id = azurerm_subnet.example_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "example_vm" {
    name = "example-vm"
    location = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.example_interface.id]
    vm_size = "Standard_DS1_v2"

    storage_image_reference {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "16.04-LTS"
      version = "latest"
    }

    storage_os_disk {
      name = "myosdisk1"
      caching = "ReadWrite"
      create_option = "FromImage"
      managed_disk_type = "Standard_LRS"
    }

    os_profile {
      computer_name = "hostname"
      admin_username = "testadmin"
      admin_password = "Password1234!"
    }

    os_profile_linux_config {
      disable_password_authentication = false
    }

    tags = {
      environment = "stg"
    }
}