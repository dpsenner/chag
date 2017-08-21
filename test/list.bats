#!/usr/bin/env bats

load test_helper

@test "list: --help prints help" {
  run ./chag list --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag list") -ne 0 ]
}

@test "list: invalid options fail" {
  run ./chag list --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "list: lists tag versions from changelog" {
  setup_changelog
  run ./chag list --file $CHNGFILE
  delete_changelog
  [ $status -eq 0 ]
  [ "${lines[0]}" == "0.0.2" ]
  [ "${lines[1]}" == "0.0.1" ]
}
