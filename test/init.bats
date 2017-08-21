#!/usr/bin/env bats

load test_helper

@test "init: --help prints help" {
  run ./chag init --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag init") -ne 0 ]
}

@test "init: invalid options fail" {
  run ./chag init --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "init: creates changelog with appropriate header" {
  run ./chag init --file $CHNGFILE
  contents=`head -n 1 $CHNGFILE`
  delete_changelog
  [ $status -eq 0 ]
  [ "$contents" == "# CHANGELOG" ]
}
