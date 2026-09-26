-- Custom stack cards now practise English: target_word holds the English gap
-- word, english_sentence the English sentence containing it. german_sentence
-- stays as the German source sentence.
--
-- Existing rows get an empty english_sentence; dropping the default afterwards
-- makes every new insert supply one.
alter table public.custom_stack_cards
  add column english_sentence text not null default '';

alter table public.custom_stack_cards
  alter column english_sentence drop default;
