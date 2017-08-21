#!/usr/bin/env bats

load test_helper

@test "entry: --help prints help" {
  run ./chag entry --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag entry --contents") -ne 0 ]
}

@test "entry: invalid options fail" {
  run ./chag entry --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}
