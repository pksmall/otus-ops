data "gitlab_user" "main-owner" {
  username = "small"
}

resource "gitlab_group_membership" "main-owner" {
  group_id     = data.gitlab_group.otus-ops.id
  user_id      = data.gitlab_user.main-owner.id
  access_level = "owner"
}
