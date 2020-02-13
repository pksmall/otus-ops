data "gitlab_group" "otus-ops" {
  full_path = "otus-ops"
}

provider "gitlab" {
  version  = "2.4.0"
  base_url = "https://gitlab.korzhenko.info/api/v4"
}

resource "gitlab_group" "apps" {
  name             = "apps"
  description      = "Applications"
  path             = "apps"
  parent_id        = data.gitlab_group.otus-ops.id
  visibility_level = "public"
}

resource "gitlab_group" "infra" {
  name             = "infra"
  description      = "Infrastructure Projects"
  path             = "infra"
  parent_id        = data.gitlab_group.otus-ops.id
  visibility_level = "public"
}
