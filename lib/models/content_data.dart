import 'package:flutter/widgets.dart';

class ContentTileData {
  const ContentTileData({required this.icon, required this.label, this.route});

  final IconData icon;
  final String label;
  final String? route;
}

class ContentSectionData {
  const ContentSectionData({required this.title, required this.tiles});

  final String title;
  final List<ContentTileData> tiles;
}

class StackProgressData {
  const StackProgressData({
    required this.learnedWords,
    required this.seenWords,
    required this.totalWords,
  });

  final int learnedWords;
  final int seenWords;
  final int totalWords;
}

class VocabularyStackData {
  const VocabularyStackData({
    required this.id,
    required this.icon,
    required this.title,
    required this.difficultyLevel,
    this.progress,
  });

  final String id;
  final IconData icon;
  final String title;
  final int difficultyLevel;
  final StackProgressData? progress;
}

/// One of the three-line entries in the "letzte 5 Wörter" card (design.md 5.17).
class RecentWordEntry {
  const RecentWordEntry({
    required this.germanWord,
    required this.germanExample,
    required this.englishExample,
  });

  final String germanWord;
  final String germanExample;
  final String englishExample;
}

/// Detail-only payload for the Stapel-Detail screen (design.md 5.17). Kept
/// separate from [VocabularyStackData] so the list screen's shape is untouched.
class StackDetailData {
  const StackDetailData({
    required this.stack,
    required this.description,
    required this.difficultyLabel,
    required this.newWordsSeen,
    required this.newWordsTotal,
    required this.learnedWords,
    required this.totalWords,
    required this.recentWords,
  });

  final VocabularyStackData stack;
  final String description;
  final String difficultyLabel;
  final int newWordsSeen;
  final int newWordsTotal;
  final int learnedWords;
  final int totalWords;
  final List<RecentWordEntry> recentWords;
}
