/// A single card of a user-created stack. [targetWord] is the German word or
/// phrase to be learned, [germanSentence] the sentence it appears in.
class CustomStackCard {
  const CustomStackCard({
    required this.id,
    required this.targetWord,
    required this.germanSentence,
  });

  final String id;
  final String targetWord;
  final String germanSentence;
}

/// In-memory only for this increment — no persistence layer yet.
class CustomStack {
  const CustomStack({this.name = 'Custom-Stapel', this.cards = const []});

  final String name;
  final List<CustomStackCard> cards;

  CustomStack copyWith({String? name, List<CustomStackCard>? cards}) =>
      CustomStack(name: name ?? this.name, cards: cards ?? this.cards);
}
