#!/bin/sh

set -eu
# This will continually relaunch the Hytale server if it is stopped.
tmux new-session -d -s hytale-session sh -c '
  while true; do
    "$@"
  done
' sh "$@"

# Keep this script running
tail -f /dev/null
