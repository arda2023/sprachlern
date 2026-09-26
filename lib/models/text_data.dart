/// The two cover palettes of design.md 5.15.
enum TextCoverPalette { dark, purple }

/// One entry of the Texte carousel (design.md 5.15).
class TextCoverData {
  const TextCoverData({
    required this.id,
    required this.title,
    required this.levelLabel,
    required this.palette,
  });

  final String id;
  final String title;

  /// Level badge text, e.g. "A1".
  final String levelLabel;
  final TextCoverPalette palette;
}

/// A piece of the reading text: either plain text or a gap.
sealed class TextSegment {
  const TextSegment();
}

class PlainTextSegment extends TextSegment {
  const PlainTextSegment(this.text);

  /// Includes its own surrounding spaces; `\n\n` starts a new paragraph.
  final String text;
}

class GapSegment extends TextSegment {
  const GapSegment({required this.baseWord, required this.answer});

  /// Shown as the placeholder inside the empty gap (design.md 5.8).
  final String baseWord;
  final String answer;
}

class TextExerciseData {
  const TextExerciseData({
    required this.title,
    required this.segments,
    required this.currentCard,
    required this.totalCards,
  });

  final String title;
  final List<TextSegment> segments;
  final int currentCard;
  final int totalCards;

  List<GapSegment> get gaps => segments.whereType<GapSegment>().toList();
}
