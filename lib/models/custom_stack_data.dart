/// A single card of a user-created stack. It practises English like the rest
/// of the app: [englishSentence] contains [targetWord], the English gap word;
/// [germanSentence] is the German sentence it was translated from.
class CustomStackCard {
  const CustomStackCard({
    required this.id,
    required this.targetWord,
    required this.englishSentence,
    required this.germanSentence,
  });

  /// Database id; empty until the card has been stored.
  final String id;
  final String targetWord;

  /// Empty only for cards stored before English sentences were introduced.
  final String englishSentence;
  final String germanSentence;
}

/// The signed-in user's stack, as loaded from Supabase.
class CustomStack {
  const CustomStack({this.name = 'Custom-Stapel', this.cards = const []});

  final String name;
  final List<CustomStackCard> cards;

  CustomStack copyWith({String? name, List<CustomStackCard>? cards}) =>
      CustomStack(name: name ?? this.name, cards: cards ?? this.cards);
}
