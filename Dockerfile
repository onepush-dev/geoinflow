# Railway wrapper around GEOInflow built unmodified from the upstream
# Dockerfile.liekan (yaojingang/GEOInflow@13c32ec) by the GHCR workflow.
# Runs the web app and both workers (log/geo worker, analytics worker) in one
# container, because they share /app/managed-geo and Railway cannot share a
# volume between services.
ARG BASE=ghcr.io/onepush-dev/geoinflow:base-13c32ec
FROM ${BASE}
USER root
RUN apk add --no-cache su-exec
COPY railway/ /app/railway/
RUN chmod 0755 /app/railway/*.sh
ENV DISABLE_TELEMETRY=1 \
    NEXT_TELEMETRY_DISABLED=1 \
    DEFAULT_LOCALE=en-US \
    API_KEY_ENABLED=1 \
    LIEKAN_GEO_DIRECTORY=/app/managed-geo \
    LIEKAN_GEO_CHINA_MODE=shadow \
    LIEKAN_AI_ENABLED=false \
    LIEKAN_ANALYSIS_SITE_LIMIT_MIB=1024 \
    LIEKAN_ANALYSIS_GLOBAL_LIMIT_MIB=8192 \
    PORT=8080 \
    HOSTNAME=0.0.0.0
EXPOSE 8080
ENTRYPOINT ["/app/railway/entrypoint.sh"]
CMD []
