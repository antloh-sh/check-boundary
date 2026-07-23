# check-boundary

## Check Service Boundary (`index.html`)

Single-file web app for checking whether a Singapore postal code falls within a service boundary.

- Looks up the postal code via the [OneMap](https://www.onemap.gov.sg/) API to resolve an address and coordinates.
- Plots the location on an interactive map (Leaflet, OpenStreetMap tiles).
- Checks the postal code against the `postal_codes` table in Supabase and reports:
  - **In service boundary** — OneMap resolved the postal code, and it's in the `postal_codes` table
  - **Out of Boundary** — OneMap resolved the postal code, but it's not in the `postal_codes` table
  - **Unknown Boundary** — OneMap could not resolve the postal code at all (invalid/not found)

No build step — open `index.html` directly or host it as a static page (e.g. GitHub Pages). It connects to Supabase using the publishable (anon) key hardcoded in the file, so only expose non-sensitive, RLS-protected data through it.

---

# supabase-daily-ping
Simple repo to run a daily ping against a Supabase RPC healthcheck using the publishable (anon) key.
Files:
- ping/healthcheck.sh — Bash script that calls POST /rest/v1/rpc/healthcheck
- .github/workflows/daily-ping.yml — GitHub Actions workflow (runs daily at 00:00 UTC)
- sql/healthcheck.sql — SQL to create the healthcheck function and grant EXECUTE to anon

1. Apply the SQL in `sql/healthcheck.sql` to your Supabase database (via psql, Studio SQL editor, or supabase CLI).
2. Create a new GitHub repository and push these files (or unzip the provided archive into a folder and push).
3. In the repository settings -> Secrets -> Actions, add two repository secrets:
   - SUPABASE_URL — your Supabase URL (e.g., https://xxxxx.supabase.co)
   - SUPABASE_ANON_KEY — your anon/publishable key
4. The workflow runs daily. You can also trigger it manually via the Actions tab.
Security:
- The script never prints secrets. The response body is redacted of any exact matches to SUPABASE_ANON_KEY just in case.
- Use the publishable/anon key only for non-sensitive checks. Do not use the service_role key in client-side or Actions contexts.
Customization:
- To change schedule, edit `.github/workflows/daily-ping.yml` cron expression.
- To increase retry attempts or change backoff, edit `ping/healthcheck.sh`.
