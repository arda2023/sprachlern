-- Run once after the migration as postgres (SQL editor).
begin;

insert into public.stacks
  (id, title, icon_name, difficulty_level, sort_order, description, difficulty_label, new_words_seen, new_words_total, learned_words, total_words)
values
  ('reisen-und-alltag', 'Reisen und Alltag', 'bookOpen', 2, 0, 'Wörter und Wendungen für unterwegs: Bahnhof, Hotel, Restaurant und kleine Gespräche zwischendurch.', 'Mittleres Niveau', 41, 126, 28, 126),
  ('nuetzliche-gespraeche', 'Nützliche Gespräche', 'messagesSquare', 1, 1, 'Kurze Sätze für den Einstieg: begrüßen, nachfragen und höflich antworten.', 'Anfänger', 0, 80, 0, 80),
  ('arbeit-und-termine', 'Arbeit und Termine', 'folderOpen', 3, 2, 'Wortschatz für Büro und Zusammenarbeit: Termine abstimmen, Aufgaben verteilen und Ergebnisse festhalten.', 'Fortgeschritten', 16, 40, 8, 40);

insert into public.stack_words
  (stack_id, german_word, german_example, english_example, sort_order)
values
  ('reisen-und-alltag', 'Gepäck', 'Mein Gepäck ist noch nicht angekommen.', 'My luggage has not arrived yet.', 0),
  ('reisen-und-alltag', 'Bahnsteig', 'Der Zug fährt von Bahnsteig drei ab.', 'The train leaves from platform three.', 1),
  ('reisen-und-alltag', 'buchen', 'Ich möchte ein Zimmer buchen.', 'I would like to book a room.', 2),
  ('reisen-und-alltag', 'Quittung', 'Können Sie mir bitte eine Quittung geben?', 'Could you give me a receipt, please?', 3),
  ('reisen-und-alltag', 'umsteigen', 'Du musst in Köln umsteigen.', 'You have to change trains in Cologne.', 4),
  ('arbeit-und-termine', 'Besprechung', 'Die Besprechung beginnt um neun Uhr.', 'The meeting starts at nine.', 0),
  ('arbeit-und-termine', 'Frist', 'Wir müssen die Frist einhalten.', 'We have to meet the deadline.', 1);

commit;
