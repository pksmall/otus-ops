provider "azurerm" {
  version = "=1.34.0"
}

resource "azurerm_resource_group" "gitops-demo" {
  name     = "gitops-demo"
  location = "West US 2"
}

# Set Environment Variable TF_VAR_client_id=00000000-0000-0000-0000-000000000000
variable "client_id" {}
# Set Environment Variable TF_VAR_client_secret=00000000000000000000000000000000
variable "client_secret" {}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "gitops-demo-aks"
  location            = azurerm_resource_group.gitops-demo.location
  resource_group_name = azurerm_resource_group.gitops-demo.name
  dns_prefix          = "gitlab"

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_F2s_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Terraform = "True"
  }
}