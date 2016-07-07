#!/usr/bin/env bats

load dsh_script

@test "Checking dsh ssh-add -D" {
	dsh ssh-add -l
}

@test "Checking dsh ssh-add -l" {
	dsh ssh-add -l
}

@test "Checking dsh ssh-add bats_rsa" {
	cp ../drude/tests/ssh-key/* ~/.ssh
	dsh ssh-add bats_rsa
}

@test "Checking dsh ssh-add: key doesn't exist" {
	run dsh ssh-add doesnt_exist_rsa

	[ $status -eq 1 ]
	[[ $output =~ "SSH key file not found:" ]]
}

@test "Checking dsh ssh-add -l (one key)" {
	run dsh ssh-add -l

	[ $status -eq 0 ]
	[[ $output =~ "4096 SHA256" ]]
}

@test "Checking dsh ssh-add -D" {
	run dsh ssh-add -D

	[ $status -eq 0 ]
	[[ $output =~ "All identities removed." ]]
}

@test "Checking dsh ssh-add -l (no keys)" {
	run dsh ssh-add -l

	[ $status -eq 0 ]
	[[ $output =~ "The agent has no identities." ]]
}

@test "Checking dsh ssh_add function" {
	run ssh_add bats_rsa

	[ $status -eq 0 ]
}