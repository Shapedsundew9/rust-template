#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf -- "$TEST_DIR"' EXIT
export COMMAND_LOG="$TEST_DIR/commands.log"

rustup() {
    printf 'rustup %s\n' "$*" >> "$COMMAND_LOG"
    if [[ "$*" == "update stable --no-self-update" ]]; then
        return "${UPDATE_STATUS:-0}"
    fi
    if [[ "$1" == "update" ]]; then
        echo "Unexpected rustup update arguments: $*" >&2
        return 1
    fi
}

cargo() {
    printf 'cargo %s\n' "$*" >> "$COMMAND_LOG"
}

export -f rustup cargo
cd "$TEST_DIR"
touch Cargo.toml

bash "$REPO_ROOT/.devcontainer/post-create.sh"
printf '%s\n' \
    'rustup update stable --no-self-update' \
    'rustup default stable' \
    'rustup component add rustfmt clippy rust-analyzer rust-src' \
    'cargo check' > expected.log
diff -u expected.log "$COMMAND_LOG"

export UPDATE_STATUS=23
: > "$COMMAND_LOG"
status=0
bash "$REPO_ROOT/.devcontainer/post-create.sh" || status=$?
if [[ "$status" -ne "$UPDATE_STATUS" ]]; then
    echo "Expected update failure $UPDATE_STATUS, got $status" >&2
    exit 1
fi
printf '%s\n' 'rustup update stable --no-self-update' > expected.log
diff -u expected.log "$COMMAND_LOG"

echo "Container setup tests passed."
