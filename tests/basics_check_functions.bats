#!/usr/bin/env bats

load dsh_script

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
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq $win ]
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

@test "Checking is_docker_beta function. Case#1 Not beta version" {
	DOCKER_BETA=0
	# Run section
	run is_docker_beta

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 1 ]
}

@test "Checking is_docker_beta function. Case#2 Beta version" {
	DOCKER_BETA=1
	# Run section
	run is_docker_beta

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 0 ]
}

@test "Checking is_binary_found function. Case#1: existing binary" {
	# Run section
	run is_binary_found 'docker'

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 0 ]

}

@test "Checking is_binary_found function. Case#2: fake binary" {
	# Run section
	run is_binary_found 'fake_binary'

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 1 ]

}

@test "Checking check_binary_found function. Case#1: existing binary" {
	# Run section
	run check_binary_found 'docker'

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 0 ]

}

@test "Checking check_binary_found function. Case#2: fake binary" {
	# Run section
	run check_binary_found 'fake_binary'

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 1 ]
}

#TODO: add all OS compatible test version, using skip for now.
@test "Checking is_docker_runnning function. Case#1: Linux docker running" {
	# Run section
	if [[ "$OS" != "linux" ]]; then
		skip "This test is available only for Linux versions."
	fi
	# start docker service if it's already running it will proceed.
	sudo service docker start
	run is_docker_running

	# Always output status and output if failed
	echo_all_info "$status" "$output" "$lines"

	[ $status -eq 0 ]
}

@test "Checking is_docker_runnning function. Case#1: Linux docker not running" {
	# Run section
	if [[ "$OS" != "linux" ]]; then
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
	echo_all_info "$status" "$output" "$lines"

	docker_state=$status

	# Start docker
	sudo service docker start
	# Start containers
	run start

	[ $docker_state -ne 0 ]
}
