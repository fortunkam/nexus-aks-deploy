resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  kubernetes_version  = local.aks_kubernetes_version
  dns_prefix          = local.aks_name

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = local.aks_default_nodepool_vm_sku
  }

  node_resource_group = local.aks_node_resource_group_name

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "aks_ip_contributor_role" {
  scope                = azurerm_public_ip.nexus_ingress.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}