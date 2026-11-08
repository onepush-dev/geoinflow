// Replace the published default password (admin/liekan) with
// LIEKAN_ADMIN_PASSWORD before the server accepts traffic. A password the
// owner already changed is never touched, so this is safe on every start.
import pg from 'pg';
import bcrypt from 'bcryptjs';

const next = process.env.LIEKAN_ADMIN_PASSWORD;
if (!next) {
  console.warn('[railway] LIEKAN_ADMIN_PASSWORD unset: default admin password left as published (change it now)');
  process.exit(0);
}
const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
await client.connect();
try {
  const { rows } = await client.query(
    `SELECT user_id, password FROM "user" WHERE username = 'admin' AND deleted_at IS NULL`,
  );
  let changed = 0;
  for (const row of rows) {
    if (['liekan', 'umami'].some((d) => bcrypt.compareSync(d, row.password))) {
      await client.query(`UPDATE "user" SET password = $1, updated_at = now() WHERE user_id = $2`, [
        bcrypt.hashSync(next, 10),
        row.user_id,
      ]);
      changed++;
    }
  }
  console.log(`[railway] default admin password ${changed ? 'replaced' : 'already changed'}`);
} finally {
  await client.end();
}
