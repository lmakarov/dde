#!/usr/bin/env bats

load dsh_script

@test "Checking check_yml function. Case#1 Linux docker-compose exists." {
	if [[ "$OS" = "linux"  || $(is_docker_beta) -ne 0 ]]; then
		run check_yml

		[ $status -eq 0 ]
	fi

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking check_yml function. Case#1 Linux docker-compose not exists." {
	if [[ "$OS" = "linux"  ]]; then
		cd ../drude
		run check_yml

		[ $status -eq 1 ]
	fi

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant exists." {
	if [[ "$OS" != "linux"  ]]; then
		# Run tests
		run check_yml

		[ $status -eq 0 ]
	fi

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}

@test "Checking check_yml function. Case#1 Win and Mac docker-compose and vagrant not exists." {
	if [[ "$OS" != "linux"  ]]; then
		# Run tests
		cd ../drude
		run check_yml

		[ $status -eq 1 ]
	fi

	# Debug section
	echo_all_info "$status" "$output" "$lines"
}
