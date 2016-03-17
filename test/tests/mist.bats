# source docker helpers
. util/docker.sh

@test "Start Container" {
  start_container "mist-test"
}

@test "Verify mist installed" {
  # ensure mist executable exists
  run docker exec "mist-test" bash -c "[ -f /usr/local/bin/mist ]"

  [ "$status" -eq 0 ]
}

@test "Stop Container" {
  stop_container "mist-test"
}
