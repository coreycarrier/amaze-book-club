-- Fix for concurrent voting race condition
-- Run this in your Supabase SQL editor (Dashboard → SQL Editor → New query)
--
-- Instead of storing all votes as a JSON array in one row (which causes
-- last-write-wins overwriting when multiple people submit simultaneously),
-- each vote now gets its own row. Concurrent upserts are safe.

CREATE TABLE IF NOT EXISTS scoring_votes (
  id          bigserial PRIMARY KEY,
  session_id  text        NOT NULL DEFAULT 'active',
  email       text        NOT NULL,
  name        text        NOT NULL,
  score       numeric(4,2) NOT NULL CHECK (score >= 1 AND score <= 5),
  updated_at  timestamptz  NOT NULL DEFAULT now(),
  UNIQUE (session_id, email)
);

-- Allow the anon key (used by the website) to read and write votes
ALTER TABLE scoring_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_scoring_votes" ON scoring_votes
  FOR ALL USING (true) WITH CHECK (true);
