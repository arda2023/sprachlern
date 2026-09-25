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
    required this.icon,
    required this.title,
    required this.difficultyLevel,
    this.progress,
  });

  final IconData icon;
  final String title;
  final int difficultyLevel;
  final StackProgressData? progress;
}
