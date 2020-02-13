resource "gitlab_project" "README" {
  name                   = "README"
  description            = "Overview of Otus-Ops Group"
  default_branch         = "master"
  namespace_id           = data.gitlab_group.otus-ops.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

resource "gitlab_project" "search_engine_crawler" {
  name                   = "search_engine_crawler"
  description            = "AutoDevOps with Dockerfile and template overides."
  default_branch         = "master"
  namespace_id           = gitlab_group.apps.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

resource "gitlab_project" "search_engine_ui" {
  name                   = "search_engine_ui"
  description            = "AutoDevOps with Dockerfile and default template"
  default_branch         = "master"
  namespace_id           = gitlab_group.apps.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

resource "gitlab_project" "search_engine" {
  name                   = "search_engine_deploy"
  description            = "Search Engine Deploy CI/CD"
  default_branch         = "master"
  namespace_id           = gitlab_group.apps.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

//
//resource "gitlab_project" "search_engine_api" {
//  name                   = "search_engine_api"
//  description            = "AutoDevOps with Dockerfile and Helm chart"
//  default_branch         = "master"
//  namespace_id           = gitlab_group.apps.id
//  shared_runners_enabled = "true"
//  visibility_level       = "public"
//}

resource "gitlab_project" "templates" {
  name             = "templates"
  default_branch   = "master"
  namespace_id     = gitlab_group.infra.id
  visibility_level = "public"
}

resource "gitlab_project" "gcp" {
  name                   = "gcp"
  default_branch         = "master"
  namespace_id           = gitlab_group.infra.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

resource "gitlab_project" "aws" {
  name                   = "aws"
  default_branch         = "master"
  namespace_id           = gitlab_group.infra.id
  shared_runners_enabled = "true"
  visibility_level       = "public"
}

//resource "gitlab_project" "azure" {
//  name                   = "azure"
//  default_branch         = "master"
//  namespace_id           = gitlab_group.infra.id
//  shared_runners_enabled = "true"
//  visibility_level       = "public"
//}
