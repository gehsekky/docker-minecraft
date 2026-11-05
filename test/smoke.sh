#!/bin/bash
# starts a real server with temporary storage and checks its lifecycle.
set -euo pipefail

cd "$(dirname "$0")/.."

# these override any values in .env
export EULA=true OPS="" MINECRAFT_DATA=mc-smoke-data

CONTAINER=mc-smoke
HEALTH_TIMEOUT=300

compose() {
    docker compose -p mc-smoke -f docker-compose.yml -f test/docker-compose.smoke.yml "$@"
}

fail() {
    echo "FAIL: $1" >&2
    docker logs --tail 40 "$CONTAINER" >&2 || true
    exit 1
}

wait_healthy() {
    local waited=0 status
    until [ "$(docker inspect -f '{{.State.Health.Status}}' "$CONTAINER")" = "healthy" ]; do
        status=$(docker inspect -f '{{.State.Status}}' "$CONTAINER")
        [ "$status" = "running" ] || fail "container is $status while waiting for healthy"
        [ "$waited" -lt "$HEALTH_TIMEOUT" ] || fail "not healthy after ${HEALTH_TIMEOUT}s"
        sleep 5
        waited=$((waited + 5))
    done
    echo "healthy after about ${waited}s"
}

# the JVM exits with 143 when it shuts down cleanly on SIGTERM
stop_cleanly() {
    local exit_code
    compose stop
    exit_code=$(docker inspect -f '{{.State.ExitCode}}' "$CONTAINER")
    [ "$exit_code" = "143" ] || [ "$exit_code" = "0" ] || fail "exit code $exit_code on stop"
    docker logs "$CONTAINER" 2>&1 | grep "All RegionFile I/O tasks to complete" > /dev/null || fail "world was not saved on stop"
}

trap 'compose down -v' EXIT

echo "--- first start"
compose up -d --build
wait_healthy
stop_cleanly

echo "--- restart"
since=$(date -u +%Y-%m-%dT%H:%M:%SZ)
compose start
wait_healthy
if docker logs --since "$since" "$CONTAINER" 2>&1 | grep "fetching paper" > /dev/null; then
    fail "paper was downloaded again on restart"
fi
stop_cleanly

echo "PASS"
