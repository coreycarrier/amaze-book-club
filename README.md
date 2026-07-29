# Book Club Website

A single-page website for running a book club: showcases the current book, upcoming
meeting, member list with RSVP counts, book history, and voting on next picks. It
includes a hidden organizer/admin panel for managing meetings and sending invites.

## Tech stack

- **Frontend:** A single static `index.html` (vanilla HTML/CSS/JS, no build step).
  Fonts from Google Fonts; all styles are inline in a `<style>` block.
- **Backend:** [Supabase](https://supabase.com) (Postgres + REST). The browser
  reads/writes via the Supabase JS client using the **anon** key (safe to be
  public; row-level security governs access).
- **Email:** [EmailJS](https://www.emailjs.com) for sending invites/notifications
  from the browser.
- **RSVP sync:** A Google Apps Script (`rsvp_sync.gs`) that pulls RSVPs from Google
  Calendar into Supabase every 15 minutes. See `RSVP_SYNC_SETUP.md`.

## Files

| File | Purpose |
| --- | --- |
| `index.html` | The entire website (UI + client logic). |
| `seed_books.sql` | Seeds the `books` table with initial data. |
| `create_meeting_config.sql` | Creates the meeting-config table. |
| `create_meeting_rsvp.sql` | Creates the `meeting_rsvp` table (written by the Apps Script). |
| `create_scoring_votes.sql` | Creates the table for voting on next picks. |
| `rsvp_sync.gs` | Google Apps Script that syncs Calendar RSVPs → Supabase. |
| `RSVP_SYNC_SETUP.md` | One-time setup guide for the RSVP sync. |

## Running locally

No build step. Serve the folder over HTTP (needed so the Supabase/EmailJS scripts
load correctly):

```bash
# Python
python3 -m http.server 8000
# then open http://localhost:8000

# or Node
npx serve .
```

Opening `index.html` directly via `file://` may work but a local server is
recommended.

## Database setup

In the Supabase project's SQL Editor, run the `.sql` files (roughly in this order):
`seed_books.sql`, `create_meeting_config.sql`, `create_meeting_rsvp.sql`,
`create_scoring_votes.sql`. Then follow `RSVP_SYNC_SETUP.md` to wire up the
Calendar → Supabase RSVP sync.

## Configuration & secrets

- The Supabase **anon** key and URL are embedded in `index.html`. This is expected
  for a Supabase client app — access is controlled by row-level security, not by
  hiding the anon key.
- The Supabase **service_role** key is a secret. It lives **only** in the Google
  Apps Script (`rsvp_sync.gs`, as `SUPABASE_SERVICE_ROLE_KEY`) and must **never**
  be committed. The copy in this repo contains a placeholder only.
