resource "random_pet" "default" {
    prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "default" {
  location = var.resource_group_location
  name = random_pet.default.id
}