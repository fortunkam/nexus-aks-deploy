resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  sku                 = "Standard"
  admin_enabled       = true


}

resource "null_resource" "push_nexus_initializer" {
  triggers = {
    build_number = "${var.init_container_tag}"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = "../src/nexus-initializer"
    command     = <<-EOT
        az acr build -r ${azurerm_container_registry.acr.name} -t nexus-initializer:latest -t nexus-initializer:${var.init_container_tag} .
    EOT
  }

  depends_on = [
    azurerm_container_registry.acr
  ]
}