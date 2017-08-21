#!/usr/bin/env bats

load test_helper

@test "add: --help prints help" {
  run ./chag add --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag add") -ne 0 ]
}

@test "add: invalid options fail" {
  run ./chag add --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "add: creates a unreleased in changelog file" {
  setup_changelog
  run ./chag add
  delete_changelog
  [ $status -eq 0 ]
}
