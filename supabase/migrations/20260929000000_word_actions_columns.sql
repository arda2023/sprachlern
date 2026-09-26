begin;

alter table public.user_word_progress
  add column if not exists is_deactivated boolean not null default false,
  add column if not exists is_favorite boolean not null default false,
  add column if not exists is_in_playlist boolean not null default false,
  add column if not exists playlist_added_at timestamptz;

-- The existing row-level policy still applies to these columns: RLS is
-- evaluated per row, and the policy requires user_id = auth.uid(). The
-- existing authenticated SELECT/INSERT/UPDATE grants cover the table.

commit;
