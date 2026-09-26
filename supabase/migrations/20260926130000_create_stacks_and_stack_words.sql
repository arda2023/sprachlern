begin;

create table public.stacks (
  id text primary key,
  title text not null,
  icon_name text not null,
  difficulty_level int not null,
  sort_order int not null unique,
  description text not null,
  difficulty_label text not null,
  -- Preserved catalog metadata, not real per-user progress.
  new_words_seen int not null,
  new_words_total int not null,
  learned_words int not null,
  total_words int not null
);

create table public.stack_words (
  id uuid primary key default gen_random_uuid(),
  stack_id text not null references public.stacks(id) on delete cascade,
  german_word text not null,
  german_example text not null,
  english_example text not null,
  sort_order int not null,
  unique (stack_id, sort_order)
);

alter table public.stacks enable row level security;
alter table public.stack_words enable row level security;

create policy stacks_authenticated_select on public.stacks
  for select to authenticated using (true);
create policy stack_words_authenticated_select on public.stack_words
  for select to authenticated using (true);

-- Override any default Supabase table grants: catalog access is read-only.
revoke all on public.stacks, public.stack_words from public, anon, authenticated;
grant select on public.stacks, public.stack_words to authenticated;

commit;
