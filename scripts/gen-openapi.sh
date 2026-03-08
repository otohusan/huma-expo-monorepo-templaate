#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SERVER_DIR="$ROOT_DIR/apps/server"
OUTPUT_FILE="$ROOT_DIR/packages/api-client/schema.json"
TMP_FILE="$OUTPUT_FILE.tmp"

PORT="${OPENAPI_PORT:-8888}"
OPENAPI_URL="${OPENAPI_URL:-http://127.0.0.1:${PORT}/openapi.json}"

if ! command -v go >/dev/null 2>&1; then
  echo "go is required. Run 'mise install' and enable mise in your shell." >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT_FILE")"

(
  cd "$SERVER_DIR"
  go run .
) >/tmp/huma-openapi.log 2>&1 &
SERVER_PID=$!

cleanup() {
  kill "$SERVER_PID" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for i in $(seq 1 60); do
  if curl -fsS "$OPENAPI_URL" -o "$TMP_FILE"; then
    mv "$TMP_FILE" "$OUTPUT_FILE"
    echo "Wrote OpenAPI schema to $OUTPUT_FILE"
    exit 0
  fi
  sleep 0.5
  if ! kill -0 "$SERVER_PID" >/dev/null 2>&1; then
    echo "Server exited before OpenAPI could be fetched. See /tmp/huma-openapi.log" >&2
    exit 1
  fi
done

echo "Timed out waiting for $OPENAPI_URL. See /tmp/huma-openapi.log" >&2
exit 1
