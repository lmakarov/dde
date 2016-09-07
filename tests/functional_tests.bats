#!/usr/bin/env bats

load "helpers/bats-support/load"
load "helpers/bats-assert/load"

@test "1.1  - Remove all non-essential services from the host - Network" {
  # Check for listening network services.
  listening_services=$(netstat -na | grep -v tcp6 | grep -v unix | grep -c LISTEN)
  if [ "$listening_services" -eq 0 ]; then
    fail "Failed to get listening services for check: $BATS_TEST_NAME"
  else
    if [ "$listening_services" -gt 5 ]; then
      fail "Host listening on: $listening_services ports"
    fi
  fi
}

@test 'assert()' {
  touch '/home/dgadiev/pass'
  assert [ -e '/home/dgadiev/pass' ]
}