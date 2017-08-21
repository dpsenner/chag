#!/usr/bin/env bats

load test_helper

@test "show: --help prints help" {
  run ./chag show --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag show") -ne 0 ]
}

@test "show: invalid options fail" {
  run ./chag show --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "show: ensures FILENAME exists" {
  run ./chag show --file /path/to/does/not/exist
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] File not found: /path/to/does/not/exist" ]
}

@test "show: ensures the tag exists" {
  setup_changelog
  run ./chag show --file $CHNGFILE --tag 9.9.9
  delete_changelog
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Tag not found" ]
}

@test "show: can contents a tag" {
  setup_changelog
  run ./chag show --file $CHNGFILE --tag 0.0.1
  delete_changelog
  [ $status -eq 0 ]
  [ "${lines[0]}" == "* Initial release." ]
}

@test "show: can contents the latest tag" {
  setup_changelog
  run ./chag show --file $CHNGFILE
  delete_changelog
  [ $status -eq 0 ]
  [ "${lines[0]}" == '* Correcting ``--debug`` description.' ]
}
