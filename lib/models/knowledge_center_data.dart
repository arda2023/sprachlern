import 'package:flutter/widgets.dart';

/// One row of a "Statistik-Zeilenkarte" in "Mein Wissenszentrum"
/// (design.md 5.6).
class KnowledgeStatEntry {
  const KnowledgeStatEntry({
    required this.id,
    required this.icon,
    required this.label,
    required this.value,
    required this.dotColor,
    required this.description,
    this.hasChevron = true,
  });

  final String id;
  final IconData icon;
  final String label;

  /// Already formatted for display (German thousands separator).
  final String value;

  final Color dotColor;

  /// Shown in the info sheet that a tap on the row opens.
  final String description;

  final bool hasChevron;
}

/// One of the two cards in "Mein Wissenszentrum": card 1 holds three rows,
/// card 2 a single row (design.md 5.6).
class KnowledgeStatCard {
  const KnowledgeStatCard({required this.entries});

  final List<KnowledgeStatEntry> entries;
}
