#!/usr/bin/env bats

@test "chag: no arguments prints usage instructions" {
  run ./chag
  [ $status -eq 0 ]
  [ $(expr "${lines[1]}" : "Usage:") -ne 0 ]
}

@test "chag: --version prints version number" {
  run ./chag --version
  [ $status -eq 0 ]
  [ $(expr "$output" : "chag [0-9][0-9.]*") -ne 0 ]
}

@test "chag: --help prints help" {
  run ./chag --help
  [ $status -eq 0 ]
  [ "${#lines[@]}" -gt 3 ]
}

@test "chag: invalid options fail" {
  run ./chag contents --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "chag: invalid commands fail" {
  run ./chag foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Available commands: contents|show|tag|latest|entries|list|update|setversion|entry|addchange|next|add|create|init" ]
}
