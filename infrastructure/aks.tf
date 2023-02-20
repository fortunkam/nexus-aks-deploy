resource "azurerm_user_assigned_identity" "mi_aks" {
  name                = local.mi_aks_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
}

resource "azurerm_role_assignment" "aks_cluster_admin_role" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azurerm_user_assigned_identity.mi_aks.principal_id
}

resource "azurerm_role_assignment" "aks_ip_contributor_role" {
  scope                = azurerm_public_ip.nexus_ingress.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.mi_aks.principal_id
}

# resource "azurerm_role_assignment" "aks_ip_contributor_role" {
#   scope                = azurerm_public_ip.nexus_ingress.id
#   role_definition_name = "Contributor"
#   principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
# }

resource "azurerm_role_assignment" "aks_kubelet_id_ip_contributor_role" {
  scope                = azurerm_public_ip.nexus_ingress.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

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
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
  }

  node_resource_group = local.aks_node_resource_group_name

  # network_profile {
  #   network_plugin    = "kubenet"
  #   load_balancer_sku = "standard"
  # }

   network_profile {
    network_plugin = "azure"
  }

  # identity {
  #   type = "SystemAssigned"
  # }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi_aks.id]
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  name                  = "nexus"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D8s_v5"
  node_count            = 3
  enable_auto_scaling   = true
  min_count             = 3
  max_count             = 5
  lifecycle {
    ignore_changes = [
      vnet_subnet_id
    ]
  }
}


resource "azurerm_role_assignment" "aks_subnet_contributor_role" {
  scope                = azurerm_subnet.aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.mi_aks.principal_id
}

resource "azurerm_role_assignment" "aks_kubelet_id_subnet_contributor_role" {
  scope                = azurerm_subnet.aks_subnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

