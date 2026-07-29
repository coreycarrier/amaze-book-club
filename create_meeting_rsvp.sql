-- Creates the meeting_rsvp table.
-- The website reads from this table (anon key, SELECT only).
-- The Google Apps Script writes to this table (service_role key, bypasses RLS).
-- Paste the whole thing into the Supabase SQL Editor and click "Run".

CREATE TABLE IF NOT EXISTS meeting_rsvp (
  id         TEXT PRIMARY KEY DEFAULT 'current',
  rsvp       JSONB       DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Seed one row so the first read before sync doesn't error.
INSERT INTO meeting_rsvp (id, rsvp)
VALUES ('current', '{}'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- RLS: anon can READ (so the site shows RSVPs), but CANNOT write.
-- Only the service_role key used by the Apps Script can write.
ALTER TABLE meeting_rsvp ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "meeting_rsvp_public_read" ON meeting_rsvp;
CREATE POLICY "meeting_rsvp_public_read" ON meeting_rsvp
  FOR SELECT
  USING (true);

-- No INSERT / UPDATE / DELETE policies = anon is blocked from writing.
-- The service_role key bypasses RLS, so the Apps Script can still upsert.
