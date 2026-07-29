-- Seed the books table with your historical reading list.
-- Paste this entire block into the Supabase SQL Editor and click "Run".
-- This will NOT touch the existing "Heart the Lover" row.

INSERT INTO books (title, date_read, rating, scores) VALUES
  ('Project Hail Mary',                  'Feb 2026', 4.46, '[]'::jsonb),
  ('Wedding People',                     'Dec 2025', 3.86, '[]'::jsonb),
  ('James',                              'Oct 2025', 3.20, '[]'::jsonb),
  ('None of This Is True',               'Aug 2025', 3.01, '[]'::jsonb),
  ('The Housemaid',                      'Jun 2025', 3.90, '[]'::jsonb),
  ('Intermezzo',                         'Apr 2025', 1.50, '[]'::jsonb),
  ('Paper Palace',                       'Jan 2025', 2.90, '[]'::jsonb),
  ('God of the Woods',                   'Nov 2024', 3.13, '[]'::jsonb),
  ('All Fours',                          'Sep 2024', 3.34, '[]'::jsonb),
  ('Dark Matter',                        'Jul 2024', 3.39, '[]'::jsonb),
  ('The Great Alone',                    'May 2024', 3.86, '[]'::jsonb),
  ('Tom Lake',                           'Mar 2024', 2.84, '[]'::jsonb),
  ('Crying in H Mart',                   'Jan 2024', 3.84, '[]'::jsonb),
  ('The One',                            'Nov 2023', 2.81, '[]'::jsonb),
  ('The Guest',                          'Sep 2023', 2.32, '[]'::jsonb),
  ('Mad Honey',                          'Aug 2023', 3.44, '[]'::jsonb),
  ('Tomorrow and Tomorrow and Tomorrow', 'Jun 2023', 4.03, '[]'::jsonb);
