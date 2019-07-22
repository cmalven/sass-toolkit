workflow "Publish" {
  resolves = ["GitHub Action for npm"]
  on = "release"
}

action "GitHub Action for npm" {
  uses = "actions/npm@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
