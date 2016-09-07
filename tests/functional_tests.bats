#!/usr/bin/env bats

@test "1.1  - Remove all non-essential services from the host - Network" {
  # Check for listening network services.
  listening_services=$(netstat -na | grep -v tcp6 | grep -v unix | grep -c LISTEN)
  fail "jk" $BATS_TEST_NAME
  if [ "$listening_services" -eq 1 ]; then
    fail "Failed to get listening services for check: $BATS_TEST_NAME"
  else
    if [ "$listening_services" -gt 5 ]; then
      fail "Host listening on: $listening_services ports"
    fi
  fi
}