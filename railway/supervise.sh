#!/bin/sh
# supervise.sh NAME CMD...  restart CMD forever with a short back-off.
name="$1"; shift
while :; do
  "$@" || echo "[railway] $name exited with status $?; restarting in 5s" >&2
  sleep 5
done
