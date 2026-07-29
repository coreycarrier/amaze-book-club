/**
 * Book Club RSVP Sync
 * ──────────────────────────────────────────────────────────────────
 * Reads the next upcoming "Book Club: <Title> by <Author>" event
 * from your Google Calendar and upserts the guest RSVPs into the
 * Supabase meeting_rsvp table. The website then renders them.
 *
 * SETUP (one-time, ~5 minutes):
 *   1. In Supabase, go to Settings → API → copy the "service_role" key
 *      (the long SECRET one, not the anon key).
 *   2. Paste it into SUPABASE_SERVICE_ROLE_KEY below, replacing the
 *      placeholder.
 *   3. In the Apps Script editor, click "Run" on the syncRsvps
 *      function once to authorize calendar + network access.
 *   4. Then click "Run" on installTrigger — this sets it to run every
 *      15 minutes automatically.
 * ──────────────────────────────────────────────────────────────────
 */

const SUPABASE_URL              = 'https://qjseewzzmdcconjmkfhu.supabase.co';
const SUPABASE_SERVICE_ROLE_KEY = 'PASTE_YOUR_SERVICE_ROLE_KEY_HERE';
const EVENT_TITLE_PREFIX        = 'Book Club:';

/**
 * Main sync function. Finds the next Book Club event and pushes RSVPs.
 * Safe to run manually any time.
 */
function syncRsvps() {
  const calendar = CalendarApp.getDefaultCalendar();

  // Search today through one year out for the next Book Club meeting.
  const now    = new Date();
  const future = new Date(now.getTime() + 365 * 24 * 60 * 60 * 1000);
  const events = calendar.getEvents(now, future);
  const event  = events.find(e => e.getTitle().indexOf(EVENT_TITLE_PREFIX) === 0);

  if (!event) {
    console.log('No upcoming "Book Club:" event found in the next 12 months.');
    return;
  }
  console.log('Found event: "' + event.getTitle() + '" on ' + event.getStartTime());

  // Build the rsvp object: { "email@x.com": "g" | "m" | "d" | "p" }
  const rsvp = {};
  event.getGuestList(true).forEach(g => {  // true = include the event owner
    const email  = g.getEmail().toLowerCase();
    const status = String(g.getGuestStatus());
    if      (status === 'YES' || status === 'OWNER') rsvp[email] = 'g';
    else if (status === 'NO')                        rsvp[email] = 'd';
    else if (status === 'MAYBE')                     rsvp[email] = 'm';
    else                                             rsvp[email] = 'p';  // INVITED / unknown
  });

  // Upsert to Supabase (id='current' is the single row we always write to).
  const url = SUPABASE_URL + '/rest/v1/meeting_rsvp?on_conflict=id';
  const response = UrlFetchApp.fetch(url, {
    method:      'post',
    contentType: 'application/json',
    headers: {
      'apikey':        SUPABASE_SERVICE_ROLE_KEY,
      'Authorization': 'Bearer ' + SUPABASE_SERVICE_ROLE_KEY,
      'Prefer':        'resolution=merge-duplicates,return=minimal'
    },
    payload: JSON.stringify({
      id:         'current',
      rsvp:       rsvp,
      updated_at: new Date().toISOString()
    }),
    muteHttpExceptions: true
  });

  const code = response.getResponseCode();
  console.log('Synced ' + Object.keys(rsvp).length + ' RSVPs → HTTP ' + code);
  if (code >= 400) console.log('Error body: ' + response.getContentText());
}

/**
 * Installs a 15-minute time-based trigger for syncRsvps.
 * Deletes any existing syncRsvps triggers first so it's safe to re-run.
 */
function installTrigger() {
  ScriptApp.getProjectTriggers().forEach(t => {
    if (t.getHandlerFunction() === 'syncRsvps') {
      ScriptApp.deleteTrigger(t);
    }
  });
  ScriptApp.newTrigger('syncRsvps').timeBased().everyMinutes(15).create();
  console.log('Trigger installed: syncRsvps will run every 15 minutes.');
}
