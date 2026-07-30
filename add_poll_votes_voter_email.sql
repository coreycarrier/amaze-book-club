-- Keys date-poll votes to a member's email instead of a free-typed name, so
-- the public poll form can use a dropdown of actual members and let someone
-- who already voted reload and edit their choices.
-- Run this in your Supabase SQL Editor (Dashboard → SQL Editor → New query)

ALTER TABLE poll_votes ADD COLUMN IF NOT EXISTS voter_email text;

CREATE UNIQUE INDEX IF NOT EXISTS poll_votes_voter_email_idx
  ON poll_votes (lower(voter_email))
  WHERE voter_email IS NOT NULL;
