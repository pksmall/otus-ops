data "gitlab_group" "otus-ops-apps" {
  full_path = "otus-ops/apps"
}

provider "gitlab" {
  base_url = "https://gitlab.korzhenko.info/api/v4"
}

resource "gitlab_group_cluster" "gke_k8s" {
  group              = data.gitlab_group.otus-ops-apps.id
  name               = google_container_cluster.primary.name
  domain             = "gke.korzhenko.info"
  environment_scope  = "gke/*"
  kubernetes_api_url = "https://${google_container_cluster.primary.endpoint}"
  kubernetes_token   = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert = trimspace(base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate))
}
