/// A row in the "Grammatik" list (design.md 5.10, "Grammatik-Zeile").
class GrammarTopicData {
  const GrammarTopicData({
    required this.id,
    required this.title,
    required this.taskDescription,
    required this.metaLabel,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String taskDescription;

  /// Meta line, e.g. "Grammatik | Level 1".
  final String metaLabel;

  /// Drives the split between the "Meine Übungen" and "Fertig" tabs.
  final bool isCompleted;
}

/// One row of the two-column table on the light explanation page (design.md 9).
class GrammarWordPair {
  const GrammarWordPair({required this.english, required this.german});

  final String english;
  final String german;
}

/// A topic in "Grammatikhinweise" (design.md 6) together with the content of
/// its light explanation page (design.md 9).
class GrammarExplanationTopicData {
  const GrammarExplanationTopicData({
    required this.id,
    required this.title,
    required this.levelLabel,
    required this.wordPairs,
    required this.warnings,
  });

  final String id;
  final String title;

  /// "Anfänger", "Mittleres Niveau" or "Fortgeschrittene".
  final String levelLabel;

  final List<GrammarWordPair> wordPairs;

  /// Bullet points of the "Achtung!" box.
  final List<String> warnings;
}
