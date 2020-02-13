data "gitlab_group" "gitops-demo-apps" {
  full_path = "gitops-demo/apps"
}

provider "gitlab" {
  version = "~> 2.4.0"
}
resource "gitlab_group_cluster" "aws_cluster" {
  group              = data.gitlab_group.gitops-demo-apps.id
  name               = module.eks.cluster_id
  domain             = "eks.gitops-demo.com"
  environment_scope  = "eks/*"
  kubernetes_api_url = module.eks.cluster_endpoint
  kubernetes_token   = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert = trimspace(base64decode(module.eks.cluster_certificate_authority_data))

}