#!/bin/bash

# Switch to drude-d7-testing folder.
cd ../../drude-d7-testing

# Run tests. Order is important.
echo "Test command: start"
bats ../drude/tests/start.bats
echo "Test command: init"
bats ../drude/tests/init.bats
echo "Test command: stop"
bats ../drude/tests/stop.bats
echo "Test command: reset"
bats ../drude/tests/reset.bats
echo "Test command: restart"
bats ../drude/tests/restart.bats
echo "Test command: drush"
bats ../drude/tests/drush.bats
echo "Test command: exec"
bats ../drude/tests/exec.bats
echo "Test command: ssh-add"
bats ../drude/tests/ssh-add.bats
echo "Test command: status"
bats ../drude/tests/status.bats
echo "Test command: update"
bats ../drude/tests/update.bats
echo "Test dsh helper functions"
bats ../drude/tests/helper_functions.bats