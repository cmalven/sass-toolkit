workflow "Test and Publish" {
  resolves = ["Publish"]
  on = "release"
}

action "Test" {
  uses = "actions/npm@master"
  args = "test"
}

action "Publish" {
  needs = "Test"
  uses = "actions/npm@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
