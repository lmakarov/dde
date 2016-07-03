#!/usr/bin/env bats

# Include dsh script for usign internal dsh function.
setup() {
  . /usr/local/bin/dsh > /dev/null

  # If you check your update in dsh.
  #. ../drude/bin/dsh > /dev/null
}