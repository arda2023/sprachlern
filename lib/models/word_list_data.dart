/// One row of the Wortlisten screen (design.md 5.10 "Wortlisten-Zeile").
class WordListEntry {
  const WordListEntry({
    required this.stackWordId,
    required this.headword,
    required this.translation,
    required this.exampleSentence,
    required this.lastSeen,
    required this.repeatCount,
    this.isCurrentlySelected = false,
    this.isFavorite = false,
    this.isDeactivated = false,
    this.isInPlaylist = false,
  });

  final String stackWordId;
  final String headword;
  final String translation;
  final String exampleSentence;

  /// Display string, e.g. "vor 3 Tagen".
  final String lastSeen;
  final int repeatCount;

  /// Puts the example sentence on the `--teal-pill` surface.
  final bool isCurrentlySelected;

  final bool isFavorite;
  final bool isDeactivated;
  final bool isInPlaylist;
}

/// Payload of the word info sheet (design.md 5.11 "Info-Sheets ohne Button").
class WordInfoData {
  const WordInfoData({
    required this.headword,
    required this.translation,
    required this.exampleSentence,
    this.note = '',
  });

  /// Upper bound of the "N / 1000" counter under the notes field.
  static const int maxNoteLength = 1000;

  final String headword;
  final String translation;
  final String exampleSentence;
  final String note;

  int get noteLength => note.length;
}
