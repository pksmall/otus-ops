provider "kubernetes" {
  version                = "~> 1.9"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  load_config_file       = false
}

resource "kubernetes_service_account" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}

resource "kubernetes_secret" "gitlab-admin" {
  metadata {
    name      = "gitlab-admin"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = "${kubernetes_service_account.gitlab-admin.metadata.0.name}"
    }
  }
  lifecycle {
    ignore_changes = [
      data
    ]
  }
  type = "kubernetes.io/service-account-token"
}

data "kubernetes_secret" "gitlab-admin-token" {
  metadata {
    name      = "${kubernetes_service_account.gitlab-admin.default_secret_name}"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "gitlab-admin" {
  metadata {
    name = "gitlab-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "gitlab-admin"
    namespace = "kube-system"
  }
}
