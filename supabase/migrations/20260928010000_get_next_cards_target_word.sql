begin;

-- The return type changed when target_word was added, so drop the old
-- five-column signature before recreating the RPC.
drop function if exists public.get_next_cards(text, int);

create or replace function public.get_next_cards(p_stack_id text, p_limit int default 20)
returns table (
  stack_word_id uuid,
  german_word text,
  german_example text,
  english_example text,
  memory_level int,
  target_word text
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
           coalesce(p.memory_level, 0), w.target_word
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

revoke all on function public.get_next_cards(text, int) from public, anon, authenticated;
grant execute on function public.get_next_cards(text, int) to authenticated;

commit;
