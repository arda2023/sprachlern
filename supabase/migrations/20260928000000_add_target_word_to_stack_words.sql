begin;

-- Required order: update and replay the seed data before enforcing NOT NULL.
-- Existing rows are filled first; only then is target_word made mandatory.
alter table public.stack_words
  add column if not exists target_word text;

update public.stack_words
set target_word = case german_word
  when 'Gepäck' then 'luggage'
  when 'Bahnsteig' then 'platform'
  when 'buchen' then 'book'
  when 'Quittung' then 'receipt'
  when 'umsteigen' then 'change trains'
  when 'Besprechung' then 'meeting'
  when 'Frist' then 'deadline'
end
where target_word is null
  and german_word in (
    'Gepäck', 'Bahnsteig', 'buchen', 'Quittung', 'umsteigen',
    'Besprechung', 'Frist'
  );

alter table public.stack_words
  alter column target_word set not null;

commit;
