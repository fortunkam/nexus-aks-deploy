resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.11.0"
  namespace        = kubernetes_namespace.cert_manager.metadata.0.name
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.cert_manager
  ]
}

resource "helm_release" "aks_ssl_addons" {
  name        = "lets-encrypt-ssl"
  chart       = "../helm/lets-encrypt-ssl"
  description = "Helm chart for let's encrypt SSL certificate issuers for Kubernetes clusters. Installed at ${timestamp()}"
  lint        = true
  depends_on = [
    helm_release.cert_manager
  ]
}