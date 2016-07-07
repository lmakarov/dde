#!/usr/bin/env bats

# Include dsh script for usign internal dsh function.
setup() {
  . /usr/local/bin/dsh > /dev/null

  # If you check your update in dsh.
  #. ../drude/bin/dsh > /dev/null

  # Current system variables.
  OS="${OS:-mac}"
}

echo_additional_lines() {
  for line in "$@"; do
    echo "+ $line"
  done
}

echo_all_info() {
  echo "+=============================================================="
  echo "+ Current status: $1"
  echo "+ Current output: $2"
  echo "+ Current lines: $3"
  echo_additional_lines "${@:4}"
  echo "+=============================================================="
}