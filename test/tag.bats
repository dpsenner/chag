#!/usr/bin/env bats

load test_helper

setup_empty_chag_config() {
  cd $CHAGREPO
  touch .chag.config
  git add .
  git commit -m "Added test chag config"
}

setup_comments_only_chag_config() {
  cd $CHAGREPO
  touch .chag.config
  echo "# some random comment" >> .chag.config
  echo "# addv=yes" >> .chag.config
  echo "# sign=yes" >> .chag.config
  git add .
  git commit -m "Added test chag config"
}

setup_addv_yes_chag_config() {
  cd $CHAGREPO
  touch .chag.config
  echo "# some random comment" >> .chag.config
  echo "addv=yes" >> .chag.config
  echo "# sign=yes" >> .chag.config
  git add .
  git commit -m "Added test chag config"
}

setup_sign_yes_chag_config() {
  cd $CHAGREPO
  touch .chag.config
  echo "# some random comment" >> .chag.config
  echo "# addv=yes" >> .chag.config
  echo "sign=yes" >> .chag.config
  git add .
  git commit -m "Added test chag config"
}

chagcmd="$BATS_TEST_DIRNAME/../chag"

@test "tag: --help prints help" {
  run ./chag tag --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag tag") -ne 0 ]
}

@test "tag: ensures FILENAME exists" {
  run ./chag tag --file /path/to/does/not/exist 0.0.1
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] File not found: /path/to/does/not/exist" ]
}

@test "tag: tags debug output" {
  setup_repo
  run $chagcmd tag --file CHANGELOG.md
  [ $status -eq 0 ]
  [ "${lines[0]}" == 'Tagging 0.0.2 with the following annotation:' ]
  [ "${lines[1]}" == '===[ BEGIN ]===' ]
  [ "${lines[2]}" == '* Correcting ``--debug`` description.' ]
  [ "${lines[3]}" == '===[  END  ]===' ]
  [ "${lines[4]}" == 'Running git command: git tag -a --cleanup=whitespace -F - 0.0.2' ]
  [ "${lines[5]}" == '[SUCCESS] Tagged 0.0.2' ]
  run git tag -l -n1 0.0.2
  cd -
  [ $status -eq 0 ]
  [ "${lines[0]}" == '0.0.2           * Correcting ``--debug`` description.' ]
  delete_repo
}

@test "tag: tags with an empty .chag.config file" {
  setup_repo
  setup_empty_chag_config
  run $chagcmd tag --file CHANGELOG.md
  [ $status -eq 0 ]
  [ "${lines[0]}" == 'Tagging 0.0.2 with the following annotation:' ]
  [ "${lines[1]}" == '===[ BEGIN ]===' ]
  [ "${lines[2]}" == '* Correcting ``--debug`` description.' ]
  [ "${lines[3]}" == '===[  END  ]===' ]
  [ "${lines[4]}" == 'Running git command: git tag -a --cleanup=whitespace -F - 0.0.2' ]
  [ "${lines[5]}" == '[SUCCESS] Tagged 0.0.2' ]
  run git tag -l -n1 0.0.2
  cd -
  [ $status -eq 0 ]
  [ "${lines[0]}" == '0.0.2           * Correcting ``--debug`` description.' ]
  delete_repo
}

@test "tag: tags with a .chag.config file that contains only comments" {
  setup_repo
  setup_comments_only_chag_config
  run $chagcmd tag --file CHANGELOG.md
  [ $status -eq 0 ]
  [ "${lines[0]}" == 'Tagging 0.0.2 with the following annotation:' ]
  [ "${lines[1]}" == '===[ BEGIN ]===' ]
  [ "${lines[2]}" == '* Correcting ``--debug`` description.' ]
  [ "${lines[3]}" == '===[  END  ]===' ]
  [ "${lines[4]}" == 'Running git command: git tag -a --cleanup=whitespace -F - 0.0.2' ]
  [ "${lines[5]}" == '[SUCCESS] Tagged 0.0.2' ]
  run git tag -l -n1 0.0.2
  cd -
  [ $status -eq 0 ]
  [ "${lines[0]}" == '0.0.2           * Correcting ``--debug`` description.' ]
  delete_repo
}

@test "tag: prefixes tag when .chag.config contains addv=yes" {
  setup_repo
  setup_addv_yes_chag_config
  run $chagcmd tag --file CHANGELOG.md
  [ $status -eq 0 ]
  [ "${lines[0]}" == 'Tagging v0.0.2 with the following annotation:' ]
  [ "${lines[1]}" == '===[ BEGIN ]===' ]
  [ "${lines[2]}" == '* Correcting ``--debug`` description.' ]
  [ "${lines[3]}" == '===[  END  ]===' ]
  [ "${lines[4]}" == 'Running git command: git tag -a --cleanup=whitespace -F - v0.0.2' ]
  [ "${lines[5]}" == '[SUCCESS] Tagged v0.0.2' ]
  run git tag -l -n1 v0.0.2
  cd -
  [ $status -eq 0 ]
  [ "${lines[0]}" == 'v0.0.2          * Correcting ``--debug`` description.' ]
  delete_repo
}

@test "tag: can force a tag" {
  setup_repo
  run $chagcmd tag --file CHANGELOG.md 0.0.2
  [ $status -eq 0 ]
  run $chagcmd tag --force --file CHANGELOG.md --tag 0.0.2
  [ $status -eq 0 ]
  [ "${lines[5]}" == '[SUCCESS] Tagged 0.0.2' ]
  cd -
  delete_repo
}
