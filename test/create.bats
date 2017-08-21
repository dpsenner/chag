#!/usr/bin/env bats

load test_helper

@test "create: --help prints help" {
  run ./chag create --help
  [ $status -eq 0 ]
  [ $(expr "${lines[0]}" : "Usage: chag create") -ne 0 ]
}

@test "create: invalid options fail" {
  run ./chag create --foo
  [ $status -eq 1 ]
  [ "${lines[0]}" == "[FAILURE] Unknown option '--foo'" ]
}

@test "create: creates changelog with appropriate header" {
  run ./chag create --file $CHNGFILE
  contents=`head -n 1 $CHNGFILE`
  delete_changelog
  [ $status -eq 0 ]
  [ "$contents" == "# CHANGELOG" ]
}
