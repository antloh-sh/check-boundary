#!/usr/bin/env bash
#
# Minimal Supabase "keep alive" ping script.
# Requires:
#   - SUPABASE_URL (e.g. https://xyzabc123.supabase.co)
#   - SUPABASE_ANON_KEY (project anon/public key)
#
# The script performs a lightweight authenticated GET to the REST endpoint.
# It prints the HTTP status and timestamp and exits 0 so CI doesn't fail on expected 401/403.
set -euo pipefail

# Validate env
if [[ -z "${SUPABASE_URL:-}" || -z "${SUPABASE_ANON_KEY:-}" ]]; then
  cat <<EOF >&2
Missing environment variables.
Please set SUPABASE_URL and SUPABASE_ANON_KEY.
Example:
  SUPABASE_URL="https://<project>.supabase.co" SUPABASE_ANON_KEY="<anon>" $0
EOF
  exit 2
fi

PING_URL="${SUPABASE_URL%/}/rest/v1/?select="

# Perform request. We send both apikey and Authorization headers (standard for Supabase).
HTTP_CODE=$(curl -sS -o /dev/null -w '%{http_code}' \
  -H "apikey: ${SUPABASE_ANON_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_ANON_KEY}" \
  -H "Content-Type: application/json" \
  --data '{}' \
  --connect-timeout 10 \
  --max-time 20 \
  "${PING_URL}" || echo "000")

TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo "${TS} - Pinged ${PING_URL} - HTTP ${HTTP_CODE}"

# Exit 0 even if 401/403 so scheduled runs don't report failure; we still generated activity.
exit 0
