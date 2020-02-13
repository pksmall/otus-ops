terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "otus-ops"

    workspaces {
      name = "gcp"
    }
  }
}
