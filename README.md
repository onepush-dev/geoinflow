# GEOInflow on Railway

[GEOInflow](https://github.com/yaojingang/GEOInflow) (MIT, upstream commit `13c32ec`) — GEO / AI-crawler web analytics — packaged for Railway: app, log/geo worker and analytics worker (one container), Postgres 16 and Redis.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/bGXbgY)

- The upstream `Dockerfile.liekan` is built unmodified by the GitHub Action into `ghcr.io/onepush-dev/geoinflow:base-13c32ec`; `Dockerfile` + `railway/` add the Railway start scripts.
- Sign in as `admin` with the generated `LIEKAN_ADMIN_PASSWORD` (Variables tab); the published default password is replaced on first boot.
- GeoIP data lives on the `/app/managed-geo` volume; Postgres data on its own volume.
