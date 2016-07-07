#!/usr/bin/env bats

load dsh_script

@test "Checking is_linux function." {
	# Value from preset variable.
	[[ "$OS" = "linux" ]] && linux=0 || linux=1

	run is_linux

	[ $status -eq $linux ]

	# Debug section
	echo "==============================================================="
	echo "Is linux: $linux"
	echo "OS: $OS"
	echo "==============================================================="

	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_windows function." {
	# Value from preset variable.
	[[ "$OS" = "win" ]] && win=0 || win=1

	run is_windows

	[ $status -eq $win ]

	# Debug section
	echo "==============================================================="
	echo "Is win: $win"
	echo "OS: $OS"
	echo "==============================================================="

	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_boot2docker function." {
	# Check if boot2docker console (@todo upd this test)
	run bash -c 'uname -a|grep "boot2docker"'
	boot2socker=$output
	is_boot2socker=$([[ ! "$boot2docker" = '' ]] && echo 0 || echo 1)

	run is_boot2docker

	[ $status -eq $is_boot2socker ]

	# Debug section
	echo "==============================================================="
	echo "Is boot2docker: $is_boot2socker"
	echo "==============================================================="

	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_mac function." {
	# Value from preset variable.
	[[ "$OS" = "mac" ]] && mac=0 || mac=1

	run is_mac

	[ $status -eq $mac ]

	# Debug section
	echo "==============================================================="
	echo "Is mac: $mac"
	echo "OS: $OS"
	echo "==============================================================="

	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_docker_beta function. Case#1 Not beta version" {
	DOCKER_BETA=0
	run is_docker_beta

	[ $status -eq 1 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_docker_beta function. Case#2 Beta version" {
	DOCKER_BETA=1
	run is_docker_beta

	[ $status -eq 0 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_binary_found function. Case#1: existing binary" {
	run is_binary_found 'docker'

	[ $status -eq 0 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_binary_found function. Case#2: fake binary" {
	run is_binary_found 'fake_binary'

	[ $status -eq 1 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking check_binary_found function. Case#1: existing binary" {
	run check_binary_found 'docker'

	[ $status -eq 0 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking check_binary_found function. Case#2: fake binary" {
	run check_binary_found 'fake_binary'

	[ $status -eq 1 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

#TODO: add all OS compatible test version, using skip for now.
@test "Checking is_docker_runnning function. Case#1: Linux docker running" {
	if [[ "$OS" != "linux" ]]; then
		skip "This test is available only for Linux versions."
	fi

	# Start docker service if it's already running it will proceed.
	sudo service docker start #@todo upd this test - don't use sudo
	run is_docker_running

	[ $status -eq 0 ]

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking is_docker_runnning function. Case#1: Linux docker not running" {
	if [[ "$OS" != "linux" ]]; then
		skip "This test is available only for Linux versions."
	fi

	# Stop containers
	run stop
	# Stop Docker service
	sudo service docker stop #@todo upd this test - don't use sudo
	sleep 1
	# Run check
	run is_docker_running
	sleep 1

	docker_state=$status

	# Start docker
	sudo service docker start
	# Start containers
	run start

	[ $docker_state -ne 0 ]

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"
}