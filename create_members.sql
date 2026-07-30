-- Members roster, synced to Supabase so every visitor and organizer session
-- sees the same list (previously the member list only lived in each browser's
-- localStorage, so members added on one device never showed up anywhere else).
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor → New query)

CREATE TABLE IF NOT EXISTS members (
  id          bigserial PRIMARY KEY,
  name        text        NOT NULL,
  email       text        NOT NULL UNIQUE,
  joined      text        NOT NULL DEFAULT '',
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- Allow the anon key (used by the website) to read and write members
ALTER TABLE members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_members" ON members
  FOR ALL USING (true) WITH CHECK (true);
