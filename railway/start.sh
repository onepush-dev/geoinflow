#!/bin/sh
# Same steps as upstream scripts/liekan-start.sh, plus: replace the published
# default admin password before the server starts, and supervise the two
# workers from upstream docker-compose.liekan.yml in this container.
set -eu
cd /app
export PATH="$PWD/node_modules/.bin:$PATH"
echo "[railway] step: liekan-schema-check.mjs"
node scripts/liekan-schema-check.mjs --migrations-only --allow-pending
echo "[railway] step: check-db.js"
node scripts/check-db.js
echo "[railway] step: liekan-schema-check.mjs"
node scripts/liekan-schema-check.mjs
echo "[railway] step: liekan-migrate.mjs"
node scripts/liekan-migrate.mjs
echo "[railway] step: liekan-seed-demo.mjs"
node scripts/liekan-seed-demo.mjs --automatic || echo "[railway] demo seed skipped"
echo "[railway] step: liekan-queue-bootstrap.mjs"
node scripts/liekan-queue-bootstrap.mjs
echo "[railway] step: update-tracker.js"
node scripts/update-tracker.js
echo "[railway] step: admin-password.mjs"
node /app/railway/admin-password.mjs

PORT="${PORT:-8080}"
(
  until node -e "fetch('http://127.0.0.1:${PORT}/api/heartbeat').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"; do sleep 3; done
  echo "[railway] app healthy; starting workers"
  /app/railway/supervise.sh log-worker env LIEKAN_GEO_UPDATER=1 node dist/liekan-worker.mjs &
  /app/railway/supervise.sh analytics-worker node --max-old-space-size=384 dist/liekan-analytics-worker.mjs &
  wait
) &
exec node server.js
