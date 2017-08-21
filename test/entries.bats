#!/usr/bin/env bats

load test_helper

@test "entries: --help prints help" {
  run ./chag entries --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag entries") -ne 0 ]
}

@test "entries: invalid options fail" {
  run ./chag entries --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "entries: lists tag versions from changelog" {
  setup_changelog
  run ./chag entries --file $CHNGFILE
  delete_changelog
  [ $status -eq 0 ]
  [ "${lines[0]}" == "0.0.2" ]
  [ "${lines[1]}" == "0.0.1" ]
}
