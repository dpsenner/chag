#!/usr/bin/env bats

load test_helper

@test "setversion: --help prints help" {
  run ./chag setversion --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag setversion") -ne 0 ]
}

@test "setversion: requires a TAG" {
  run ./chag setversion
  [ $status -eq 1 ]
  [ $(expr "${lines[0]}" : ".* setversion requires a TAG") -ne 0 ]
}

@test "setversion: ensures FILENAME exists" {
  run ./chag setversion --file /path/to/does/not/exist FOO
  [ $status -eq 1 ]
  [ "${lines[0]}" ==  "[FAILURE] File not found: /path/to/does/not/exist" ]
}

@test "setversion: updates inline" {
  setup_changelog_tbd
  run ./chag setversion --file $CHNGFILE 9.9.9
  [ $status -eq 0 ]
  delete_changelog
  date=$(date +%Y-%m-%d)
  [ "${lines[0]}" == "[SUCCESS] Updated ${CHNGFILE} with 9.9.9" ]
}
