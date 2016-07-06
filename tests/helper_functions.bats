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
 echo $output

 [ $status -eq 0 ]
 [ $output = "$(pwd)" ]
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

@test "Checking get_current_relative_path function. #1 Inside docroot folder condition" {
  # Run section
  cd docroot/sites/all
  run get_current_relative_path

  # Debug section
  echo "+=============================================================="
  local proj_root=$(get_yml_path)
  echo "+ Project root: $proj_root"
  local cwd=$(pwd)
  echo "+ Current directory: $cwd"
  local pathdiff=${cwd#$proj_root/}
  echo "+ Path diff: $pathdiff"
  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = "docroot/sites/all" ]
}

@test "Checking get_current_relative_path function. #2 Outside docroot folder condition" {
  # Run section
  run get_current_relative_path

  # Debug section
  echo "+=============================================================="
  local proj_root=$(get_yml_path)
  echo "+ Project root: $proj_root"
  local cwd=$(pwd)
  echo "+ Current directory: $cwd"
  local pathdiff=${cwd#$proj_root/}
  echo "+ Path diff: $pathdiff"
  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = "" ]
}

@test "Checking clean_string function" {
  # Run section
  local string="Abc-123/"
  run clean_string $string

  # Debug section
  local cleaned=$(echo "$string" | sed -e 's/[^a-zA-Z0-9_-]$//')
  echo ${cleaned}
  echo "+=============================================================="
  echo "+ Input string: $string"

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = "Abc-123" ]
}

@test "Checking get_mysql_connect function. Case#1 Outside of docroot" {
  # Run section
  run get_mysql_connect

  # Debug section
  echo "==============================================================="
  echo "Output of sql-connect with disabled TTY: $(DRUDE_IS_TTY=0 _run drush sql-connect)"
  echo "==============================================================="
  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+ Current checked value: ${lines[8]}"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "${lines[8]}" = "#1 [internal function]: drush_sql_connect()" ]
}

@test "Checking get_mysql_connect function. Case#1 Inside of docroot" {
  # Run section
  cd docroot/sites
  run get_mysql_connect

  # Debug section
  echo "==============================================================="
  echo "Output of sql-connect with disabled TTY: $(DRUDE_IS_TTY=0 _run drush sql-connect)"
  echo "==============================================================="
  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = "mysql --user=drupal --password=123 --database=drupal --host=172.17.0.5" ]
}