# RSVP Sync Setup

This is a one-time setup. Once done, every 15 minutes Google Calendar RSVPs
will automatically flow into your Supabase `meeting_rsvp` table, and the
website will show the right counts on the "Next Meeting" card and the
member cards.

## Step 1 — Create the Supabase table

1. Open Supabase → SQL Editor
2. Paste the entire contents of `create_meeting_rsvp.sql`
3. Click **Run**
4. Confirm in the Table Editor that `meeting_rsvp` now shows up in the
   table list.

## Step 2 — Grab your Supabase service_role key

The Apps Script needs a key that can write to the `meeting_rsvp` table.
Your site already uses the anon key; that one only has read access here.
The service_role key bypasses RLS.

1. Supabase → **Project Settings** (gear icon) → **API**
2. Find the section titled **Project API keys**
3. Copy the **`service_role`** key (it's marked "secret" — the long one,
   NOT the `anon` one)
4. Keep it in your clipboard for the next step. Do not paste it into the
   website code or check it into git. It only goes into Apps Script.

## Step 3 — Create the Apps Script

1. Go to https://script.google.com
2. Click **New project**
3. Name it something like "Book Club RSVP Sync"
4. Delete any boilerplate code in the editor
5. Open `rsvp_sync.gs` from your workspace folder and paste the entire
   contents into the Apps Script editor
6. Find the line:
   ```
   const SUPABASE_SERVICE_ROLE_KEY = 'PASTE_YOUR_SERVICE_ROLE_KEY_HERE';
   ```
   and replace the placeholder with the service_role key you copied in
   Step 2.
7. Click the **save** icon (or ⌘S).

## Step 4 — Authorize and test

1. In the function dropdown at the top of the Apps Script editor, select
   **`syncRsvps`**
2. Click **Run**
3. Google will prompt you to authorize — approve access to Calendar and
   external URL fetch. (You may see a "This app isn't verified" warning
   because it's your own private script — click **Advanced** → **Go to
   project** → **Allow**.)
4. Open the **Execution log** (bottom of the screen). You should see
   something like:
   ```
   Found event: "Book Club: Strangers by Belle Burden" on ...
   Synced 23 RSVPs → HTTP 201
   ```
5. Refresh your book club website. The "Next Meeting" card should now
   show "✓ 10 going", "13 no reply", etc.

## Step 5 — Turn on the 15-minute auto-sync

1. In the function dropdown, select **`installTrigger`**
2. Click **Run**
3. The log should say: `Trigger installed: syncRsvps will run every 15 minutes.`
4. You can verify under **Triggers** (clock icon in left sidebar) that
   `syncRsvps` has a time-driven trigger.

You're done. From now on, any RSVP change in Google Calendar will land
on the website within 15 minutes.

## How the calendar event needs to be named

The Apps Script looks for the next calendar event whose title starts
with `Book Club:`. The "Send Calendar Invite" button in the organizer
section now generates this exact format automatically:

```
Book Club: <Book Title> by <Author>
```

So as long as you keep using that button to create invites (and don't
rename the event in Calendar afterwards), the sync will keep working
for all future meetings with no changes needed.

## Troubleshooting

- **"No upcoming Book Club: event found"** — make sure the event title
  starts with exactly `Book Club:` (colon included). The sync looks in
  your primary (`corey.fink@gmail.com`) calendar. If the invite was
  created in a different calendar, change `CalendarApp.getDefaultCalendar()`
  in the script to `CalendarApp.getCalendarById('other@example.com')`.
- **HTTP 401 / 403 from Supabase** — the service_role key is wrong,
  expired, or the `meeting_rsvp` table doesn't exist yet. Re-check
  Steps 1 and 2.
- **Counts never update on the website** — hard-refresh (⌘+Shift+R).
  The page fetches RSVPs once on load; there's no live subscription.
