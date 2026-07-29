-- Creates the meeting_config table used by the site to persist the next meeting
-- (book, author, ISBN, date, time, location). Paste the whole thing into the
-- Supabase SQL Editor and click "Run". Safe to re-run — uses IF NOT EXISTS.

CREATE TABLE IF NOT EXISTS meeting_config (
  id             TEXT PRIMARY KEY DEFAULT 'current',
  book           TEXT,
  author         TEXT,
  isbn           TEXT,
  date_display   TEXT,
  time_display   TEXT,
  location       TEXT,
  date_iso       TEXT,
  date_iso_end   TEXT,
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);

-- Seed one row. The site always upserts into id='current'.
INSERT INTO meeting_config (id, book, author, isbn, date_display, time_display, location, date_iso, date_iso_end)
VALUES ('current', 'Strangers', 'Belle Burden', '', 'TBD', '7:00 – 9:00 PM', '', '', '')
ON CONFLICT (id) DO NOTHING;

-- RLS: same pattern as your books / poll_config tables — permissive so the
-- site's anon client can read + write. Organizer password is the real gate.
ALTER TABLE meeting_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "meeting_config_all_access" ON meeting_config;
CREATE POLICY "meeting_config_all_access" ON meeting_config
  FOR ALL
  USING (true)
  WITH CHECK (true);
