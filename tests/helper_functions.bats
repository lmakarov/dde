#!/usr/bin/env bats

load dsh_script

true_if_failed() {
  true
  if_failed
}

@test "Checking if_failed function. Text #1" {
 run true_if_failed

 [ $status -eq 0 ]
}

not_true_if_failed() {
  ! true
  if_failed
}

@test "Checking if_failed function. Text #2" {
 run not_true_if_failed

 [ $status -eq 1 ]
}

@test "Checking upfind function. Text #1" {
 run upfind $(pwd)/docroot/sites

 [ $status -eq 0 ]
 [ $output = $(pwd) ]
}

@test "Checking upfind function. Text #2" {
 run upfind $(pwd)/dir_not_exists

 [ $status -eq 0 ]
 [ "$output" = "" ]
}

@test "Checking upfind function. Text #3" {
 run upfind ""

 [ $status -eq 1 ]
}

@test "Checking get_yml_path function" {
 run get_yml_path

 [ $status -eq 0 ]
 [ $output = $(pwd) ]
}

@test "Checking get_drude_path function" {
 run get_drude_path

 [ $status -eq 0 ]
 [ $output = $(pwd) ]
}

@test "Checking get_abs_path function" {
 run get_abs_path ./docroot/sites

 [ $status -eq 0 ]
 [ "$output" = "$(pwd)/docroot/sites" ]
}
