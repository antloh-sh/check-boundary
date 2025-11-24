```markdown
# Supabase keep-alive / ping

This repository contains a small script and a scheduled GitHub Action to "ping" a Supabase project to prevent the free tier from pausing it due to inactivity.

How it works
- The script makes a minimal authenticated GET request to the Supabase REST endpoint (/rest/v1/?select=).
- The GitHub Action runs the script on a schedule and uses repository secrets so your anon key is not exposed.

Setup
1. In your GitHub repo, go to Settings → Secrets and variables → Actions → New repository secret.
   - Add `SUPABASE_URL` (e.g. `https://xyzabc123.supabase.co`)
   - Add `SUPABASE_ANON_KEY` (the anon/public API key from Project Settings → API)

2. Commit the files in this repo (the `.github/workflows` workflow and `scripts/ping-supabase.sh`).

3. The action runs daily by default. You can adjust the schedule in `.github/workflows/ping-supabase.yml`.

Local usage
- Make the script executable:
  chmod +x scripts/ping-supabase.sh

- Run with environment variables:
  SUPABASE_URL="https://<your-project>.supabase.co" SUPABASE_ANON_KEY="<anon-key>" ./scripts/ping-supabase.sh

Notes
- The script uses the anon key and performs a harmless GET; it does not modify data.
- If you'd rather use a different endpoint (Auth, Health, or a small RPC) you can modify the URL in the script.
```
