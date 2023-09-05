# RESOURCE GROUP
resource "azurerm_resource_group" "default" {
    name = "rg"
    location = var.location_name
}

# VIRTUAL NETWORK
resource "azurerm_virtual_network" "default" {
    name = "vn"
    address_space = ["10.0.0.0/16"]
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name
}

# SUBNET
resource "azurerm_subnet" "default" {
    name = "subnet"
    resource_group_name = azurerm_resource_group.default.name
    virtual_network_name = azurerm_virtual_network.default.name
    address_prefixes = [ "10.0.1.0/24" ]
}

# PUBLIC IP
resource "azurerm_public_ip" "default" {
    name = "default-ip"
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name
    allocation_method = "Dynamic"
}

# NSG(NETWORK SECURITY GROUP)
resource "azurerm_network_security_group" "default" {
    name = "nsg"
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name

    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
}

# NETWORK INTERFACE
resource "azurerm_network_interface" "default" {
    name = "ni"
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.default.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.default.id
    }
}

# SECURITY GROUP ASSOCIATION
resource "azurerm_network_interface_security_group_association" "default" {
    network_interface_id = azurerm_network_interface.default.id
    network_security_group_id = azurerm_network_security_group.default.id
}

# STORAGE ACCOUNT
resource "azurerm_storage_account" "default" {
    name = "strgac20230906"
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name
    account_tier = "Standard"
    account_replication_type = "LRS"
}

# VM(VIRTUAL MACHINE)
resource "azurerm_linux_virtual_machine" "default" {
    name = "vm"
    location = var.location_name
    resource_group_name = azurerm_resource_group.default.name
    network_interface_ids = [ azurerm_network_interface.default.id ]
    size = "Standard_DS1_v2"

    os_disk {
        name = "onDisk"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "8-lvm-gen2"
        version = "latest"
    }

    computer_name = "hostname"
    admin_username = var.user_name

    admin_ssh_key {
        username = var.user_name
        public_key = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.default.primary_blob_endpoint
    }
}