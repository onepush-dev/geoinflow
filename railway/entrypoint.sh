#!/bin/sh
# Root only to hand the geo volume to the app user, then drop privileges.
set -eu
mkdir -p /app/managed-geo
chown -R nextjs:nodejs /app/managed-geo 2>/dev/null || true
exec su-exec nextjs:nodejs /app/railway/start.sh
