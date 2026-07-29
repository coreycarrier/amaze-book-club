# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this is

A single-page book club website. The entire app lives in **`index.html`** —
vanilla HTML/CSS/JS with no build step, no framework, no bundler. Data is stored
in Supabase and accessed from the browser via the Supabase JS client. See
`README.md` for the full stack and file breakdown.

## Working conventions

- **No build/run step.** To preview, serve the folder over HTTP
  (`python3 -m http.server 8000`) and open the local URL. There is nothing to
  compile.
- **Everything is in `index.html`.** Styles are in a single `<style>` block using
  CSS custom properties defined under `:root` (the color palette — `--pink`,
  `--coral`, `--green`, etc.). Reuse these variables instead of hardcoding colors.
  Client logic is in `<script>` blocks in the same file.
- **Keep it dependency-light.** External libs are loaded via CDN
  (`@supabase/supabase-js`, `@emailjs/browser`). Don't introduce a build toolchain
  or npm dependency tree unless explicitly asked.

## Secrets — important

- The Supabase **anon** key in `index.html` is public by design; do not treat it
  as a leak or try to hide it.
- Never commit the Supabase **service_role** key. It belongs only in the Google
  Apps Script (`rsvp_sync.gs`) and the committed copy holds a placeholder. If you
  ever see a real service_role key about to be committed, stop and flag it.

## Database

Schema changes go in the `.sql` files and are applied manually in the Supabase SQL
Editor. Tables: `books`, meeting config, `meeting_rsvp`, and scoring/votes. The
Apps Script writes to `meeting_rsvp`; see `RSVP_SYNC_SETUP.md`.

## Making changes

- Prefer small, targeted edits to `index.html`. Because it's one large file, be
  precise about which section (nav, hero, meeting card, member list, history,
  voting, admin panel) you're touching.
- After UI changes, sanity-check by serving locally and loading the page.
