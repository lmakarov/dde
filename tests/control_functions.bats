#!/usr/bin/env bats

load dsh_script

@test "Checking check_yml function. Case#1 Linux docker-compose exists." {
	if [[ "$OS" = "linux"  || $(is_docker_beta) -ne 0 ]]; then
		# Run tests
		run check_yml

		echo_all_info "$status" "$output" "$lines"

		[ $status -eq 0 ]
	fi
}

@test "Checking check_yml function. Case#1 Linux docker-compose not exists." {
	if [[ "$OS" = "linux"  ]]; then
		cd ../drude
		# Run tests
		run check_yml

		echo_all_info "$status" "$output" "$lines"

		[ $status -eq 1 ]
	fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant exists." {
	if [[ "$OS" != "linux"  ]]; then
		# Run tests
		run check_yml

		echo_all_info "$status" "$output" "$lines"

		[ $status -eq 0 ]
	fi
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant not exists." {
	if [[ "$OS" != "linux"  ]]; then
		# Run tests
		cd ../drude
		run check_yml

		echo_all_info "$status" "$output" "$lines"

		[ $status -eq 1 ]
	fi
}
