begin;

create table public.user_word_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  stack_word_id uuid not null references public.stack_words(id) on delete cascade,
  easiness_factor float not null default 2.5,
  interval_days int not null default 0,
  repetitions int not null default 0,
  next_due_at timestamptz not null default now(),
  last_seen_at timestamptz,
  memory_level int not null default 0 check (memory_level between 0 and 5),
  unique (user_id, stack_word_id)
);

alter table public.user_word_progress enable row level security;

create policy user_word_progress_own_rows on public.user_word_progress
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

revoke all on public.user_word_progress from public, anon, authenticated;
grant select, insert, update on public.user_word_progress to authenticated;

create function public.submit_answer(p_stack_word_id uuid, p_correct boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_ef float;
  v_interval int;
  v_reps int;
  v_memory_level int;
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_stack_word_id is null or p_correct is null then
    raise exception 'Word ID and answer must not be null' using errcode = '22004';
  end if;

  -- Create the initial row, then lock it to serialize concurrent answers.
  insert into public.user_word_progress (user_id, stack_word_id)
  values (v_user_id, p_stack_word_id)
  on conflict (user_id, stack_word_id) do nothing;

  select p.easiness_factor, p.interval_days, p.repetitions
    into v_ef, v_interval, v_reps
    from public.user_word_progress as p
    where p.user_id = v_user_id and p.stack_word_id = p_stack_word_id
    for update;

  if p_correct then
    v_reps := v_reps + 1;
    v_interval := case
      when v_reps = 1 then 1
      when v_reps = 2 then 6
      else round(v_interval * v_ef)::int
    end;
    v_ef := greatest(1.3, v_ef + 0.1);
  else
    v_reps := 0;
    v_interval := 1;
    v_ef := greatest(1.3, v_ef - 0.2);
  end if;

  v_memory_level := case
    when v_reps = 0 then 0
    when v_reps = 1 then 1
    when v_reps = 2 then 2
    when v_interval < 21 then 3
    when v_interval < 90 then 4
    else 5
  end;

  insert into public.user_word_progress (
    user_id, stack_word_id, easiness_factor, interval_days, repetitions,
    next_due_at, last_seen_at, memory_level
  ) values (
    v_user_id, p_stack_word_id, v_ef, v_interval, v_reps,
    now() + (v_interval || ' days')::interval, now(), v_memory_level
  )
  on conflict (user_id, stack_word_id) do update set
    easiness_factor = excluded.easiness_factor,
    interval_days = excluded.interval_days,
    repetitions = excluded.repetitions,
    next_due_at = excluded.next_due_at,
    last_seen_at = excluded.last_seen_at,
    memory_level = excluded.memory_level;
end;
$$;

create function public.get_next_cards(p_stack_id text, p_limit int default 20)
returns table (
  stack_word_id uuid,
  german_word text,
  german_example text,
  english_example text,
  memory_level int
)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;
  if p_limit is null or p_limit < 0 then
    raise exception 'Limit must be non-null and non-negative' using errcode = '22023';
  end if;

  return query
    select w.id, w.german_word, w.german_example, w.english_example,
           coalesce(p.memory_level, 0)
    from public.stack_words as w
    left join public.user_word_progress as p
      on p.stack_word_id = w.id and p.user_id = v_user_id
    where w.stack_id = p_stack_id
      and (p.id is null or p.next_due_at <= now())
    order by
      case when p.id is null then 1 else 0 end,
      p.next_due_at asc nulls last,
      w.sort_order asc,
      w.id asc
    limit p_limit;
end;
$$;

-- Functions otherwise inherit EXECUTE for PUBLIC by default.
revoke all on function public.submit_answer(uuid, boolean) from public, anon, authenticated;
revoke all on function public.get_next_cards(text, int) from public, anon, authenticated;
grant execute on function public.submit_answer(uuid, boolean) to authenticated;
grant execute on function public.get_next_cards(text, int) to authenticated;

commit;
