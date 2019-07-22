workflow "Publish" {
  resolves = ["GitHub Action for npm"]
  on = "release"
}

action "Test" {
  uses = "actions/npm@master"
  args = "test"
}

action "Publish" {
  uses = "actions/npm@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
