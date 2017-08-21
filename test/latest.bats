#!/usr/bin/env bats

load test_helper

@test "latest: --help prints help" {
  run ./chag latest --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag latest") -ne 0 ]
}

@test "latest: invalid options fail" {
  run ./chag latest --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "latest: shows latest tag" {
  setup_changelog
  run ./chag latest --file $CHNGFILE
  delete_changelog
  [ $status -eq 0 ]
  [ "${lines[0]}" == "0.0.2" ]
}
