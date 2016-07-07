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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines" "Current checked value: ${lines[8]}"

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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines"


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
  echo_all_info "$status" "$output" "$lines"

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
  echo_all_info "$status" "$output" "$lines"

  # Check results section
  [ $status -eq 0 ]
  [ "$output" = $compose_output ]
}

@test "Checking is_linux function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Value from preset variable.
  [[ "$OS" = "linux" ]] && linux=0 || linux=1

  # Debug section
  echo "==============================================================="
  echo "Is linux: $linux"
  echo "OS: $OS"
  echo "==============================================================="

  # Run test itself
  run is_linux

  # Always output status and output if failed
  echo_all_info "$status" "$output" "$lines"

  [ $status -eq $linux ]
}

@test "Checking is_windows function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Value from preset variable.
  [[ "$OS" = "win" ]] && win=0 || win=1

  # Debug section
  echo "==============================================================="
  echo "Is win: $win"
  echo "OS: $OS"
  echo "==============================================================="

  # Run test itself
  run is_windows

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq $win ]
}

@test "Checking is_mac function." {
  # Debug section.
  # @todo add test case checking that win and linux can't be true

  # Value from preset variable.
  [[ "$OS" = "mac" ]] && mac=0 || mac=1

  # Debug section
  echo "==============================================================="
  echo "Is mac: $mac"
  echo "OS: $OS"
  echo "==============================================================="

  # Run test itself
  run is_mac

  # Always output status and output if failed
  echo_all_info "$status" "$output" "$lines"

  [ $status -eq $mac ]
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
  echo_all_info "$status" "$output" "$lines"

  [ $status -eq $is_boot2socker ]
}

@test "Checking is_docker_beta function. Case#1 Not beta version" {
  DOCKER_BETA=0
  # Run section
  run is_docker_beta

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 1 ]
}

@test "Checking is_docker_beta function. Case#2 Beta version" {
  DOCKER_BETA=1
  # Run section
  run is_docker_beta

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 0 ]
}

@test "Checking is_binary_found function. Case#1: existing binary" {
  # Run section
  run is_binary_found 'docker'

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 0 ]

}

@test "Checking is_binary_found function. Case#2: fake binary" {
  # Run section
  run is_binary_found 'fake_binary'

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 1 ]

}

@test "Checking check_binary_found function. Case#1: existing binary" {
  # Run section
  run check_binary_found 'docker'

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 0 ]

}

@test "Checking check_binary_found function. Case#2: fake binary" {
  # Run section
  run check_binary_found 'fake_binary'

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 1 ]
}

#TODO: add all OS compatible test version, using skip for now.
@test "Checking is_docker_runnning function. Case#1: Linux docker running" {
  # Run section
  if [[ $(is_linux) -ne 0 ]]; then
    skip "This test is available only for Linux versions."
  fi
  # start docker service if it's already running it will proceed.
  sudo service docker start
  run is_docker_running

  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  [ $status -eq 0 ]
}

@test "Checking is_docker_runnning function. Case#1: Linux docker not running" {
  # Run section
  if [[ $(is_linux) -ne 0 ]]; then
    skip "This test is available only for Linux versions."
  fi
  # Stop containers
  run stop
  # Stop Docker service
  sudo service docker stop
  sleep 1
  # Run check
  run is_docker_running
  sleep 1
  # Always output status and output if failed
  echo "+=============================================================="
  echo "+ Current status: $status"
  echo "+ Current output: $output"
  echo "+ Current lines: $lines"
  echo "+=============================================================="

  docker_state=$status

  # Start docker
  sudo service docker start
  # Start containers
  run start

  [ $docker_state -ne 0 ]
}

@test "Checking check_yml function. Case#1 Linux docker-compose exists." {
  if [[ $(is_linux) -ne 0 || $(is_docker_beta) -ne 0 ]]; then
	  # Run tests
	  run check_yml

	  echo "+=============================================================="
	  echo "+ Current status: $status"
	  echo "+ Current output: $output"
	  echo "+ Current lines: $lines"
	  echo "+=============================================================="

	  [ $status -eq 0 ]
  fi
}

@test "Checking check_yml function. Case#1 Linux docker-compose not exists." {
  if [[ $(is_linux) -ne 0 ]]; then
	cd ../drude
	# Run tests
	run check_yml

	echo "+=============================================================="
	echo "+ Current status: $status"
	echo "+ Current output: $output"
	echo "+ Current lines: $lines"
	echo "+=============================================================="

	  [ $status -eq 1 ]
  fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant exists." {
  if [[ $(is_windows) -ne 0 || $(is_mac) -ne 0 ]]; then
	# Run tests
	run check_yml

	echo "+=============================================================="
	echo "+ Current status: $status"
	echo "+ Current output: $output"
	echo "+ Current lines: $lines"
	echo "+=============================================================="

	  [ $status -eq 0 ]
  fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant not exists." {
  if [[ $(is_windows) -ne 0 || $(is_mac) -ne 0 ]]; then
	# Run tests
	cd ../drude
	run check_yml

	echo "+=============================================================="
	echo "+ Current status: $status"
	echo "+ Current output: $output"
	echo "+ Current lines: $lines"
	echo "+=============================================================="

	[ $status -eq 1 ]
  fi
}
