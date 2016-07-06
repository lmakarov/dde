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

@test "Checking get_current_relative_path function. Case#1: Inside docroot folder condition" {
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

@test "Checking get_current_relative_path function. Case#2: Outside docroot folder condition" {
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

@test "Checking clean_string function." {
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

@test "Checking get_mysql_connect function. Case#1: Outside of docroot" {
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

@test "Checking get_mysql_connect function. Case#2: Inside of docroot" {
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

@test "Checking docker_compose function. Case#1: Call without specified command" {
  # Run section
  run docker_compose

  # Debug section
  cwd=$(pwd)
  echo "+=============================================================="
  echo "+ Current path: $cwd"
  cd $(get_yml_path)
  echo "+ Yml path directory: $(pwd)"


  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 1 ]
  [ "${lines[0]}" = "Define and run multi-container applications with Docker." ]
}

@test "Checking docker_compose function. Case#2: Call with specified command" {
  # Run section
  run docker_compose version

  # Debug section
  cwd=$(pwd)
  echo "+=============================================================="
  echo "+ Current path: $cwd"
  cd $(get_yml_path)
  echo "+ Yml path directory: $(pwd)"


  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
}

@test "Checking get_container_id function. Case#1: cli" {
  # Run section
  run get_container_id 'cli'

  # Debug section
  echo "==============================================================="
  echo "Docker compose output: "
  compose_output=$(docker-compose ps -q cli | tr -d '\r')
  echo $compose_output
  echo "==============================================================="

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = $compose_output ]
}

@test "Checking get_container_id function. Case#2: web" {
  # Run section
  run get_container_id 'web'

  # Debug section
  echo "==============================================================="
  echo "Docker compose output: "
  compose_output=$(docker-compose ps -q web | tr -d '\r')
  echo $compose_output
  echo "==============================================================="

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = $compose_output ]
}

@test "Checking is_linux function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Check if OS is Linux
  run bash -c 'uname | grep "Linux"'
  linux=$output
  is_linux=$([[ "$linux" = 'Linux' ]] && echo 0 || echo 1)

  # Check if OS is Mac
  run bash -c 'uname | grep "Darwin"'
  mac=$output
  is_mac=$([[ "$mac" = 'Darwin' ]] && echo 0 || echo 1)

  # Check if OS is Win
  run bash -c 'uname | grep "CYGWIN_NT"'
  is_win=$([[ "$win" = 'CYGWIN_NT' ]] && echo 0 || echo 1)

  # Debug section
  echo "==============================================================="
  echo "Is linux: $is_linux"
  echo "Is mac: $is_mac"
  echo "Is win: $is_win"
  echo "==============================================================="

  # Run test itself
  run is_linux

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq $is_linux ]

}

@test "Checking is_windows function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Check if OS is Linux
  run bash -c 'uname | grep "Linux"'
  linux=$output
  is_linux=$([[ "$linux" = 'Linux' ]] && echo 0 || echo 1)

  # Check if OS is Mac
  run bash -c 'uname | grep "Darwin"'
  mac=$output
  is_mac=$([[ "$mac" = 'Darwin' ]] && echo 0 || echo 1)

  # Check if OS is Win
  run bash -c 'uname | grep "CYGWIN_NT"'
  is_win=$([[ "$win" = 'CYGWIN_NT' ]] && echo 0 || echo 1)

  # Debug section
  echo "==============================================================="
  echo "Is linux: $is_linux"
  echo "Is mac: $is_mac"
  echo "Is win: $is_win"
  echo "==============================================================="

  # Run test itself
  run is_windows

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq $is_win ]

}

@test "Checking is_mac function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Check if OS is Linux
  run bash -c 'uname | grep "Linux"'
  linux=$output
  is_linux=$([[ "$linux" = 'Linux' ]] && echo 0 || echo 1)

  # Check if OS is Mac
  run bash -c 'uname | grep "Darwin"'
  mac=$output
  is_mac=$([[ "$mac" = 'Darwin' ]] && echo 0 || echo 1)

  # Check if OS is Win
  run bash -c 'uname | grep "CYGWIN_NT"'
  is_win=$([[ "$win" = 'CYGWIN_NT' ]] && echo 0 || echo 1)

  # Debug section
  echo "==============================================================="
  echo "Is linux: $is_linux"
  echo "Is mac: $is_mac"
  echo "Is win: $is_win"
  echo "==============================================================="

  # Run test itself
  run is_mac

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq $is_mac ]

}

@test "Checking is_boot2docker function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Check if boot2docker console
  run bash -c 'uname -a|grep "boot2docker"'
  boot2socker=$output
  is_boot2socker=$([[ ! "$boot2docker" = '' ]] && echo 0 || echo 1)

  # Debug section
  echo "==============================================================="
  echo "Is boot2socker: $is_boot2socker"
  echo "==============================================================="

  # Run test itself
  run is_boot2docker

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq $is_boot2socker ]

}
