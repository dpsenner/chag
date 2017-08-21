#!/usr/bin/env bats

load test_helper

@test "addchange: --help prints help" {
  run ./chag addchange --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag addchange --contents") -ne 0 ]
}

@test "addchange: invalid options fail" {
  run ./chag addchange --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}
